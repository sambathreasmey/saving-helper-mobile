import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/dashboard_model.dart';
import 'package:saving_helper/models/requests/get_dashboard_request.dart';
import '../constants/app_color.dart' as app_color;
import '../constants/app_global.dart' as app_global;
import '../repository/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository homeRepository;
  HomeController(this.homeRepository);

  Rx<DashboardModel?> dashboard = Rx<DashboardModel?>(null);

  @override
  void onInit() {
    super.onInit();
    getDashboard();
  }

  Future<void> getDashboard() async {
    try {
      var getDashboardRequest = GetDashboardRequest(
        channelId: app_global.channelId,
      );
      final response = await homeRepository.getDashboard(getDashboardRequest);

      if (response.resultMessage!.status == 0) {
        dashboard.value = response.dashboard;
      } else {
        Get.snackbar("បរាជ័យ", response.resultMessage!.message ?? "Get user information failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }

}