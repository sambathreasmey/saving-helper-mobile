import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/models/requests/get_report_request.dart';
import 'package:saving_helper/repository/report_repository.dart';
import '../constants/app_color.dart' as app_color;
import '../constants/app_global.dart' as app_global;

class ReportController extends GetxController {
  final ReportRepository reportRepository;
  ReportController(this.reportRepository);

  RxList<ReportModel?> reports = RxList<ReportModel?>([]);
  RxString selectedTransactionType = "".obs;
  var isLoading = false.obs;

  Future<void> fetchTransactions() async {
    try {
      var request = GetReportRequest(
        channelId: app_global.channelId,
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

}