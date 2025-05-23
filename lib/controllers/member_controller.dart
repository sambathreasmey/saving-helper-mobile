import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/repository/member_repository.dart';
import 'package:saving_helper/services/share_storage.dart';

import '../constants/app_color.dart' as app_color;
import '../models/responses/group_member_response.dart' as GroupMemberResponse;

class MemberController extends GetxController {
  final MemberRepository memberRepository;

  MemberController(this.memberRepository);

  final ShareStorage shareStorage = ShareStorage();

  RxBool isLoading = false.obs;

  Rxn<List<GroupMemberResponse.Data>> groupMembers = Rxn<List<GroupMemberResponse.Data>>();


  Future<void> getMember() async {
    isLoading.value = true;
    try {
      final response = await memberRepository.getMember();
      if (response.status == 0) {
        groupMembers.value = response.data;
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

  Future<void> deleteMember(String userId) async {
    try {
      final groupId = shareStorage.getGroupId();
      var request = {
        "user_id": userId,
        "group_id": groupId
      };
      final response = await memberRepository.deleteMember(request);

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
