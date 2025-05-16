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
import '../screen/home_screen.dart';
import '../services/share_storage.dart';

class ReportRepayController extends GetxController {
  final ReportRepository reportRepository;
  ReportRepayController(this.reportRepository);

  RxList<ReportModel?> reports = RxList<ReportModel?>([]);
  RxString selectedTransactionType = "".obs;
  var isLoading = false.obs;
  RxString repayAmount = ''.obs;
  RxString repayDesc = ''.obs;
  RxString repayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  RxBool isRepayFormVisible = false.obs;

  Future<void> fetchTransactions() async {
    try {
      final ShareStorage shareStorage = ShareStorage();
      final userId = await shareStorage.getUserCredential();
      final groupId = await shareStorage.getGroupId();
      var request = GetReportRequest(
        channelId: app_global.channelId,
        userId: userId!,
        groupId: groupId!,
        reportType: selectedTransactionType.value,
      );
      final response = await reportRepository.getReport(request);

      if (response.resultMessage!.status == 0) {
        reports.value = response.reports!;
      } else {
        Get.snackbar("បរាជ័យ", response.resultMessage!.message ?? "Get report failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }

  Future<void> repayLoan(String transactionId) async {
    try {
      var repayLoanReq = RepayLoanRequest(
        channelId: app_global.channelId,
        transactionId: transactionId,
        repayAmount: repayAmount.value,
        repayDate: repayDate.value,
        repayDesc: repayDesc.value,
      );
      final response = await reportRepository.repayLoan(repayLoanReq);

      if (response.status == 0) {
        Get.snackbar("ទទួលបានជោគជ័យ", response.message ?? "Login successful", colorText: app_color.background, icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor));
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Login failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }

  Future<void> deleteRepayLoan(String repayId, String transactionId) async {
    try {
      var deleteRepayLoanReq = DeleteRepayLoanRequest(
        channelId: app_global.channelId,
        transactionId: transactionId,
        repayId: repayId,
      );
      final response = await reportRepository.deleteRepayLoan(deleteRepayLoanReq);

      if (response.status == 0) {
        Get.snackbar("ទទួលបានជោគជ័យ", response.message ?? "Login successful", colorText: app_color.background, icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor));
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Login failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }

}