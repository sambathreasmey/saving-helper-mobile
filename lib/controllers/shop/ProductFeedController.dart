import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/requests/get_goal_request.dart';
import 'package:saving_helper/repository/goal_management_repository.dart';
import '../../constants/app_color.dart' as app_color;
import '../../models/responses/get_goal_response.dart' as GetSummaryReportResponse;
import '../../services/share_storage.dart';

class ProductFeedController extends GetxController {
  final GoalManagementRepository goalManagementRepository;
  ProductFeedController(this.goalManagementRepository);

  RxList<GetSummaryReportResponse.Data> data = RxList<GetSummaryReportResponse.Data>([]);
  var isLoading = false.obs;
  RxBool hasMore = true.obs;
  int pageNum = 1;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (isLoading.value) return; // prevent duplicate calls
    if (!hasMore.value && !refresh) return; // no more data unless refreshing

    try {
      isLoading.value = true;
      if (refresh) {
        pageNum = 1;
        hasMore.value = true;
        data.clear();
      }

      final ShareStorage shareStorage = ShareStorage();
      final userId = await shareStorage.getUserCredential();

      var request = GetGoalRequest(
        userId: userId!,
        pageNum: pageNum,
        pageSize: pageSize,
      );

      final response = await goalManagementRepository.getGoals(request);

      if (response.status == 0) {
        final newReports = response.data ?? [];
        if (refresh) {
          data.value = newReports;
        } else {
          data.addAll(newReports);
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