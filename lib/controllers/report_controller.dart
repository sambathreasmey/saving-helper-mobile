import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/models/requests/get_report_request.dart';
import 'package:saving_helper/repository/report_repository.dart';

import '../constants/app_color.dart' as app_color;
import '../constants/app_global.dart' as app_global;
import '../models/requests/DeleteTransactionRequest.dart';
import '../services/share_storage.dart';

class ReportController extends GetxController {
  final ReportRepository reportRepository;
  ReportController(this.reportRepository);

  // State
  final reports = <ReportModel?>[].obs;
  final selectedTransactionType = "".obs;
  final isLoading = false.obs;
  final hasMore = true.obs;

  int pageNum = 1;
  final int pageSize = 10;

  // Important: let the SCREEN trigger the first fetch with refresh:true.
  // Avoid double-fetch by not auto-calling here.
  @override
  void onInit() {
    super.onInit();
    // do not call fetchTransactions() here if your screen already does it
  }

  Future<void> fetchTransactions({bool refresh = false}) async {
    // Prevent duplicate calls
    if (isLoading.value) return;

    // If we're not refreshing and there's no more data, stop
    if (!hasMore.value && !refresh) return;

    if (refresh) {
      pageNum = 1;
      hasMore.value = true;
      reports.clear();
    }

    isLoading.value = true;
    try {
      final shareStorage = ShareStorage();
      final userId = await shareStorage.getUserCredential();
      final groupId = await shareStorage.getGroupId();

      final request = GetReportRequest(
        channelId: app_global.channelId,
        userId: userId!,
        groupId: groupId!,
        reportType: selectedTransactionType.value,
        pageNum: pageNum,
        pageSize: pageSize,
      );

      final response = await reportRepository.getReport(request);

      if ((response.resultMessage?.status ?? -1) == 0) {
        final newReports = response.reports ?? <ReportModel>[];

        // Append / replace
        if (refresh) {
          reports.value = newReports;
        } else {
          reports.addAll(newReports);
        }

        // Paging decision:
        // - Short or empty page => no more
        // - Exactly pageSize => likely more
        if (newReports.length < pageSize) {
          hasMore.value = false;
        } else {
          hasMore.value = true;
          pageNum++;
        }
      } else {
        // Backend error message
        Get.snackbar(
          "បរាជ័យ",
          response.resultMessage?.message ?? "Get report failed",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor),
        );

        // If this happened while paginating (not refreshing),
        // stop the spinner loop by marking no more.
        if (!refresh) hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "ប្រព័ន្ធមានបញ្ហា",
        e.toString(),
        colorText: app_color.background,
        icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor),
      );

      // On paging error (not refresh), prevent endless retries at bottom
      if (!refresh) hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    // Optimistic remove from list so UI matches Dismissible
    final index = reports.indexWhere((e) => e?.transactionId == transactionId);
    ReportModel? removed;
    if (index != -1) {
      removed = reports[index];
      reports.removeAt(index);
    }

    try {
      final request = DeleteTransactionRequest(
        channelId: app_global.channelId,
        transactionId: transactionId,
      );

      final response = await reportRepository.deleteTransaction(request);
      if ((response.status ?? -1) == 0) {
        Get.snackbar(
          "ទទួលបានជោគជ័យ",
          response.message ?? "Deleted",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor),
        );
      } else {
        // Revert if backend failed
        if (removed != null) {
          reports.insert(index.clamp(0, reports.length), removed);
        }
        Get.snackbar(
          "បរាជ័យ",
          response.message ?? "Delete failed",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor),
        );
      }
    } catch (e) {
      // Revert on error
      if (removed != null) {
        reports.insert(index.clamp(0, reports.length), removed);
      }
      Get.snackbar(
        "ប្រព័ន្ធមានបញ្ហា",
        e.toString(),
        colorText: app_color.background,
        icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor),
      );
    }
  }
}
