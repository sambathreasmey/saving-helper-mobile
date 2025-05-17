import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/responses/get_user_info_response.dart';
import 'package:saving_helper/repository/invite_repository.dart';
import 'package:saving_helper/screen/home_screen.dart';

import '../constants/app_color.dart' as app_color;
import '../models/responses/get_owner_response.dart' as GetOwnerGroupResponse;
import '../models/responses/get_user_info_response.dart' as GetUserInfoResponse;

class InviteController extends GetxController {
  final InviteRepository inviteRepository;

  InviteController(this.inviteRepository);

  RxBool isLoading = false.obs;

  Rxn<List<GetOwnerGroupResponse.Data>> groups = Rxn<List<GetOwnerGroupResponse.Data>>();
  Rxn<GetUserInfoResponse.Data> foundUser = Rxn<GetUserInfoResponse.Data>();

  final TextEditingController searchController = TextEditingController();
  String? selectedGroup;

  bool validate() {
    return username.isNotEmpty && selectedGroup != null;
  }

  String get username => searchController.text.trim();

  /// Clears input and selection, but does NOT dispose the controller
  void clear() {
    searchController.clear();
    selectedGroup = null;
    foundUser.value = null;
  }

  /// ⚠️ DO NOT dispose searchController manually, handled by GetX lifecycle
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> getOwnerGroup() async {
    isLoading.value = true;
    try {
      final response = await inviteRepository.getOwnerGroup();
      if (response.status == 0) {
        groups.value = response.data;
      } else {
        Get.snackbar(
          "មានបញ្ហា",
          response.message ?? "បរាជ័យក្នុងការទាញយកក្រុម",
          colorText: app_color.background,
          icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor),
        );
      }
    } catch (e) {
      Get.snackbar(
        "មានបញ្ហា",
        e.toString(),
        colorText: app_color.background,
        icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> findUserByUsername() async {
    isLoading.value = true;
    try {
      final response = await inviteRepository.findUserByUsername(username);
      if (response.status == 0 && response.data != null) {
        foundUser.value = response.data;
        final userId = response.data!.id;
        inviteUser(userId!);
        // Clear state and navigate to home
        clear();
        Get.off(() => HomeScreen());
      } else {
        foundUser.value = null;
        Get.snackbar(
          "រកមិនឃើញ",
          response.message ?? "User not found",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.person_off, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        "មានបញ្ហា",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> inviteUser(String userId) async {
    isLoading.value = true;
    try {
      final response = await inviteRepository.inviteUser(userId, selectedGroup!);

      if (response.status == 0) {
        Get.snackbar(
          "ជោគជ័យ",
          response.message ?? "បានអញ្ជើញរួចរាល់!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );

        clear();
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar(
          "បរាជ័យ",
          response.message ?? "បរាជ័យក្នុងការអញ្ជើញ",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        "មានបញ្ហា",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

}
