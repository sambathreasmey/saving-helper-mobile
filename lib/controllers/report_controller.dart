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

  RxList<ReportModel?> reports = RxList<ReportModel?>([]);
  RxString selectedTransactionType = "".obs;
  var isLoading = false.obs;

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

  Future<void> deleteTransaction(String transactionId) async {
    try {
      var request = DeleteTransactionRequest(
        channelId: app_global.channelId,
        transactionId: transactionId,
      );
      print(request.transactionId);
      final response = await reportRepository.deleteTransaction(request);

      if (response.status == 0) {
        Get.snackbar("ទទួលបានជោគជ័យ", response.message ?? "Login successful", colorText: app_color.background, icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor));
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Login failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }

}