import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/models/requests/delete_repay_loan_request.dart';
import 'package:saving_helper/models/requests/get_report_request.dart';
import 'package:saving_helper/models/requests/repay_loan_request.dart';
import 'package:saving_helper/repository/report_repository.dart';

import '../constants/app_color.dart' as app_color;
import '../constants/app_global.dart' as app_global;
import '../models/repay_laon_model.dart';
import '../services/share_storage.dart';

class ReportRepayController extends GetxController {
  final ReportRepository reportRepository;
  ReportRepayController(this.reportRepository);

  // ====== Reactive State ======
  final reports = <ReportModel?>[].obs;         // list for UI
  final selectedTransactionType = 'loan'.obs;   // default to loan
  final isLoading = false.obs;                  // network in-flight
  final hasMore = true.obs;                     // paging sentinel

  // repay form state
  final repayAmount = ''.obs;
  final repayDesc = ''.obs;
  final repayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  final isRepayFormVisible = false.obs;

  // paging
  int _pageNum = 1;
  final int _pageSize = 10;

  /// Set type (e.g., 'loan') and refresh list from page 1
  Future<void> setTypeAndRefresh(String type) async {
    selectedTransactionType.value = type;
    await fetchTransactions(refresh: true);
  }

  void resetPaging() {
    _pageNum = 1;
    hasMore.value = true;
    reports.clear();
  }

  /// Fetch transactions with paging. Use `refresh: true` for pull-to-refresh or when filter changes.
  Future<void> fetchTransactions({bool refresh = false}) async {
    // prevent duplicate calls
    if (isLoading.value) return;

    // don't fetch past the end unless refresh
    if (!hasMore.value && !refresh) return;

    if (refresh) {
      resetPaging();
    }

    isLoading.value = true;
    try {
      final shareStorage = ShareStorage();
      final userId = await shareStorage.getUserCredential();
      final groupId = await shareStorage.getGroupId();

      final req = GetReportRequest(
        channelId: app_global.channelId,
        userId: userId!,
        groupId: groupId!,
        reportType: selectedTransactionType.value,
        // If your API supports paging, keep these:
        pageNum: _pageNum,
        pageSize: _pageSize,
      );

      final res = await reportRepository.getReport(req);

      if ((res.resultMessage?.status ?? -1) == 0) {
        final newItems = (res.reports ?? <ReportModel>[]);

        if (refresh) {
          reports.value = newItems;
        } else {
          reports.addAll(newItems);
        }

        // paging decision: short or empty page => no more
        if (newItems.length < _pageSize) {
          hasMore.value = false;
        } else {
          hasMore.value = true;
          _pageNum++;
        }
      } else {
        Get.snackbar(
          "បរាជ័យ",
          res.resultMessage?.message ?? "Get report failed",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor),
        );
        // stop infinite loop at bottom
        if (!refresh) hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "ប្រព័ន្ធមានបញ្ហា",
        e.toString(),
        colorText: app_color.background,
        icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor),
      );
      if (!refresh) hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Optimistic repay: updates UI immediately, then calls API. Falls back on error.
  Future<void> repayLoan(String transactionId) async {
    // locate the txn
    final idx = reports.indexWhere((e) => e?.transactionId == transactionId);
    if (idx < 0) {
      Get.snackbar("មិនរកឃើញ", "ប្រតិបត្តិការមិនមានទេ", colorText: app_color.background);
      return;
    }
    final txn = reports[idx]!;
    final amount = double.tryParse(repayAmount.value.trim()) ?? 0.0;
    final desc = repayDesc.value.trim();
    final date = repayDate.value;

    if (amount <= 0) {
      Get.snackbar("មិនត្រឹមត្រូវ", "ចំណូលប្រាក់សងត្រូវធំជាង 0", colorText: app_color.background);
      return;
    }
    if ((txn.remainBalance ?? 0) <= 0) {
      Get.snackbar("មិនត្រឹមត្រូវ", "គ្មានបំណុលនៅសល់", colorText: app_color.background);
      return;
    }
    if (amount > (txn.remainBalance ?? 0)) {
      Get.snackbar("មិនត្រឹមត្រូវ", "ចំនួនប្រាក់សងលើសកម្ចីដែលនៅសល់", colorText: app_color.background);
      return;
    }

    // optimistic UI update
    final oldRemain = txn.remainBalance ?? 0.0;
    txn.remainBalance = (oldRemain - amount).clamp(0.0, double.infinity);
    txn.repayLoanDetails ??= [];
    txn.repayLoanDetails!.insert(0, RepayLoanDetail(
      repayAmount: amount,
      repayDate: date,
      repayDesc: desc,
      repayId: "", // unknown until backend responds
    ));
    reports[idx] = txn; // trigger Rx refresh

    try {
      final req = RepayLoanRequest(
        channelId: app_global.channelId,
        transactionId: transactionId,
        repayAmount: amount.toString(),
        repayDate: date,
        repayDesc: desc,
      );

      final res = await reportRepository.repayLoan(req);

      if ((res.status ?? -1) == 0) {
        // if backend returns IDs or updated remain, you can re-fetch this txn for accuracy
        Get.snackbar(
          "ទទួលបានជោគជ័យ",
          res.message ?? "Repayment recorded",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor),
        );
        // Optional: refresh the first page to reflect server-calculated values
        // await fetchTransactions(refresh: true);
      } else {
        // revert optimistic change
        txn.remainBalance = oldRemain;
        txn.repayLoanDetails?.removeAt(0);
        reports[idx] = txn;

        Get.snackbar(
          "បរាជ័យ",
          res.message ?? "Repayment failed",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor),
        );
      }
    } catch (e) {
      // revert optimistic change on error
      txn.remainBalance = oldRemain;
      txn.repayLoanDetails?.removeAt(0);
      reports[idx] = txn;

      Get.snackbar(
        "ប្រព័ន្ធមានបញ្ហា",
        e.toString(),
        colorText: app_color.background,
        icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor),
      );
    }
  }

  /// Optimistic delete of a repayment entry, then call API; revert on failure.
  Future<void> deleteRepayLoan(String repayId, String transactionId) async {
    // locate txn and the repay detail
    final tIndex = reports.indexWhere((e) => e?.transactionId == transactionId);
    if (tIndex < 0) {
      Get.snackbar("មិនរកឃើញ", "ប្រតិបត្តិការមិនមានទេ", colorText: app_color.background);
      return;
    }
    final txn = reports[tIndex]!;
    final list = txn.repayLoanDetails ?? [];
    final rIndex = list.indexWhere((d) => (d.repayId ?? '') == repayId);
    if (rIndex < 0) {
      // If repayId not present (newly created optimistic or backend didn’t return id),
      // try matching by last item or amount/date/desc if needed.
      Get.snackbar("មិនរកឃើញ", "មិនអាចលុបប្រតិបត្តិការសងប្រាក់នេះបានទេ", colorText: app_color.background);
      return;
    }

    final removed = list[rIndex];
    // optimistic remove + update remain balance
    list.removeAt(rIndex);
    final oldRemain = txn.remainBalance ?? 0.0;
    final removedAmount = removed.repayAmount ?? 0.0;
    txn.remainBalance = oldRemain + removedAmount;
    txn.repayLoanDetails = List<RepayLoanDetail>.from(list);
    reports[tIndex] = txn;

    try {
      final req = DeleteRepayLoanRequest(
        channelId: app_global.channelId,
        transactionId: transactionId,
        repayId: repayId,
      );

      final res = await reportRepository.deleteRepayLoan(req);
      if ((res.status ?? -1) == 0) {
        Get.snackbar(
          "ទទួលបានជោគជ័យ",
          res.message ?? "Deleted",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor),
        );
        // Optional: refresh this txn from server to be exact
        // await fetchTransactions(refresh: true);
      } else {
        // revert
        txn.repayLoanDetails!.insert(rIndex, removed);
        txn.remainBalance = oldRemain;
        reports[tIndex] = txn;

        Get.snackbar(
          "បរាជ័យ",
          res.message ?? "Delete failed",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor),
        );
      }
    } catch (e) {
      // revert on error
      txn.repayLoanDetails!.insert(rIndex, removed);
      txn.remainBalance = oldRemain;
      reports[tIndex] = txn;

      Get.snackbar(
        "ប្រព័ន្ធមានបញ្ហា",
        e.toString(),
        colorText: app_color.background,
        icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor),
      );
    }
  }

  /// Optional helper to remove a whole transaction (if your UI swipes to delete)
  Future<void> deleteTransaction(String transactionId) async {
    // Implement here if your repo supports deleteTransaction for loans
    // This controller mainly focuses on repay flows.
  }
}
