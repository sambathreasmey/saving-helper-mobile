import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/services/share_storage.dart';
import 'package:saving_helper/repository/header_repository.dart';
import 'package:saving_helper/constants/app_color.dart' as app_color;
import '../models/responses/get_user_info_response.dart' as GetUserInfoResponse;

class HeaderController extends GetxController {
  final HeaderRepository headerRepository;
  HeaderController(this.headerRepository);

  final ShareStorage shareStorage = ShareStorage();

  Rx<GetUserInfoResponse.Data?> userInfo = Rx<GetUserInfoResponse.Data?>(null);
  Rx<String?> notificationMessage = "".obs;
  RxBool isLoadingUserInfo = false.obs;
  RxBool isLoadingNotification = false.obs;
  RxString currentGroupId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadGroupIdFromPrefs();
    getUserInfo();
  }

  Future<void> _loadGroupIdFromPrefs() async {
    final storedGroupId = await shareStorage.getGroupId();
    if (storedGroupId != null) {
      currentGroupId.value = storedGroupId;
    }
  }

  Future<void> _saveGroupIdToPrefs(String groupId) async {
    await shareStorage.saveGroupId(groupId);
  }

  Future<void> getUserInfo() async {
    isLoadingUserInfo.value = true;
    try {
      final response = await headerRepository.getUserInfo();
      if (response.status == 0) {
        userInfo.value = response.data;

        final groups = response.data?.groups ?? [];
        if (groups.isNotEmpty) {
          // If no stored group, default to first group
          final foundGroup = groups.firstWhereOrNull((g) => g.groupId?.toString() == currentGroupId.value);
          currentGroupId.value = (foundGroup?.groupId?.toString() ?? groups.first.groupId?.toString() ?? '');
        }
      } else {
        Get.snackbar("មានបញ្ហា", response.message ?? "Get user information failed",
            colorText: app_color.background,
            icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("មានបញ្ហា", e.toString(),
          colorText: app_color.background,
          icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    } finally {
      isLoadingUserInfo.value = false;
    }
  }

  void switchGroup(String groupId) {
    if (groupId == currentGroupId.value) return;

    currentGroupId.value = groupId;
    _saveGroupIdToPrefs(groupId); // 👈 Save to shared prefs
  }

  Future<void> getNotification() async {
    isLoadingNotification.value = true;
    try {
      final response = await headerRepository.notification();
      if (response.status == 0) {
        notificationMessage.value = response.message;
      } else {
        Get.snackbar("មានបញ្ហា", response.message ?? "Login failed",
            colorText: app_color.background,
            icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("មានបញ្ហា", e.toString(),
          colorText: app_color.background,
          icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    } finally {
      isLoadingNotification.value = false;
    }
  }
}
