import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/requests/update_user_email_request.dart';
import 'package:saving_helper/models/requests/update_user_full_name_request.dart';
import 'package:saving_helper/models/responses/login_response.dart' as LoginResponse;
import 'package:saving_helper/repository/account_repository.dart';
import 'package:saving_helper/services/share_storage.dart';

class AccountInformationController extends GetxController {
  final AccountRepository accountRepository;
  AccountInformationController(this.accountRepository);

  final isLoading = false.obs;

  /// Reactive user (so UI auto-rebuilds)
  final Rxn<LoginResponse.Data> user = Rxn<LoginResponse.Data>();

  /// Display-only helper
  String get displayFullName =>
      (user.value?.fullName?.isNotEmpty ?? false) ? user.value!.fullName! : "N/A";

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final storage = ShareStorage();
    final u = await storage.getUser();
    user.value = u; // <- triggers Obx
  }

  Future<void> updateFullName(String newFullName) async {
    final v = newFullName.trim();
    if (v.isEmpty) {
      Get.snackbar(
        "មិនត្រឹមត្រូវ",
        "សូមបញ្ចូលឈ្មោះ",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    try {
      isLoading.value = true;

      final storage = ShareStorage();
      final current = await storage.getUser();
      final userId = current?.userId;

      if (userId == null || userId.isEmpty) {
        Get.snackbar(
          "បរាជ័យ",
          "រកមិនឃើញលេខសម្គាល់អ្នកប្រើ",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
        return;
      }

      final req = UpdateUserFullNameRequest(userId: userId, fullName: v);
      final resp = await accountRepository.updateUserFullName(req);

      if ((resp.status ?? -1) == 0) {
        // persist locally (ShareStorage should provide setUser; rename if yours differs)
        if (current != null) {
          current.fullName = v;
          await storage.saveUser(current);
          user.value = current; // update reactive value
          user.refresh();       // ensure refresh of listeners
        }

        Get.snackbar(
          "ជោគជ័យ",
          resp.message ?? "បានកែប្រែឈ្មោះរួចរាល់!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      } else {
        Get.snackbar(
          "បរាជ័យ",
          resp.message ?? "បរាជ័យក្នុងការកែប្រែឈ្មោះ",
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

  Future<void> updateEmail(String newEmail) async {
    final v = newEmail.trim();
    if (v.isEmpty) {
      Get.snackbar(
        "មិនត្រឹមត្រូវ",
        "សូមបញ្ចូលអ៊ីមែល",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    try {
      isLoading.value = true;

      final storage = ShareStorage();
      final current = await storage.getUser();
      final userId = current?.userId;

      if (userId == null || userId.isEmpty) {
        Get.snackbar(
          "បរាជ័យ",
          "រកមិនឃើញលេខសម្គាល់អ្នកប្រើ",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
        return;
      }

      final req = UpdateUserEmailRequest(userId: userId, email: v);
      final resp = await accountRepository.updateUserEmail(req);

      if ((resp.status ?? -1) == 0) {
        // persist locally (ShareStorage should provide setUser; rename if yours differs)
        if (current != null) {
          current.email = v;
          await storage.saveUser(current);
          user.value = current; // update reactive value
          user.refresh();       // ensure refresh of listeners
        }

        Get.snackbar(
          "ជោគជ័យ",
          resp.message ?? "បានកែប្រែអ៊ីមែលរួចរាល់!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      } else {
        Get.snackbar(
          "បរាជ័យ",
          resp.message ?? "បរាជ័យក្នុងការកែប្រែអ៊ីមែល",
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