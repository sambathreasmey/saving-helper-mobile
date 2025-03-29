import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/user_info_model.dart';
import 'package:saving_helper/repository/header_repository.dart';

import 'package:saving_helper/constants/app_color.dart' as app_color;

class HeaderController extends GetxController {
  final HeaderRepository headerRepository;
  HeaderController(this.headerRepository);

  Rx<UserInfo?> userInfo = Rx<UserInfo?>(null);
  Rx<String?> notificationMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      final response = await headerRepository.getUserInfo();

      if (response.resultMessage!.status == 0) {
        userInfo.value = response.data;
      } else {
        Get.snackbar("បរាជ័យ", response.resultMessage!.message ?? "Get user information failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្dfdfdរព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }

  Future<void> getNotification() async {
    try {
      final response = await headerRepository.notification();

      if (response.status == 0) {
        notificationMessage.value = response.message;
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Login failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }
}