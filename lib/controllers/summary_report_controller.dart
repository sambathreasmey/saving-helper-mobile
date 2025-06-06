import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/requests/get_summary_report_request.dart';
import 'package:saving_helper/repository/summary_report_repository.dart';
import '../constants/app_color.dart' as app_color;
import '../constants/app_global.dart' as app_global;
import '../models/responses/get_summary_report_response.dart' as GetSummaryReportResponse;
import '../services/share_storage.dart';

class SummaryReportController extends GetxController {
  final SummaryReportRepository summaryReportRepository;
  SummaryReportController(this.summaryReportRepository);

  RxList<GetSummaryReportResponse.Data> summaryData = RxList<GetSummaryReportResponse.Data>([]);
  RxString selectedTransactionType = "".obs;
  var isLoading = false.obs;
  RxBool hasMore = true.obs;
  int pageNum = 1;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchSummaryReport();
  }

  Future<void> fetchSummaryReport({bool refresh = false}) async {
    if (isLoading.value) return; // prevent duplicate calls
    if (!hasMore.value && !refresh) return; // no more data unless refreshing

    try {
      isLoading.value = true;
      if (refresh) {
        pageNum = 1;
        hasMore.value = true;
        summaryData.clear();
      }

      final ShareStorage shareStorage = ShareStorage();
      final groupId = await shareStorage.getGroupId();

      var request = GetSummaryReportRequest(
        channelId: app_global.channelId,
        groupId: groupId!,
        pageNum: pageNum,
        pageSize: pageSize,
      );

      final response = await summaryReportRepository.getSummaryReport(request);

      if (response.status == 0) {
        final newReports = response.data ?? [];
        if (refresh) {
          summaryData.value = newReports;
        } else {
          summaryData.addAll(newReports);
        }
        if (newReports.length < pageSize) {
          hasMore.value = false; // no more pages
        } else {
          pageNum++;
        }
      } else {
        Get.snackbar(
          "បរាជ័យ",
          response.message ?? "Get report failed",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor),
        );
      }
    } catch (e) {
      Get.snackbar(
        "ប្រព័ន្ធមានបញ្ហា",
        e.toString(),
        colorText: app_color.background,
        icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor),
      );
    } finally {
      isLoading.value = false;
    }
  }

}