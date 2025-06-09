import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/repository/saving_plan_calculate_repository.dart';
import '../models/responses/saving_plan_calculate_response.dart' as SavingPlanCalculateResponse;

class SavingPlanCalculateController extends GetxController {
  final SavingPlanCalculateRepository savingPlanCalculateRepository;

  SavingPlanCalculateController(this.savingPlanCalculateRepository) {
    final now = DateTime.now();
    final oneMonthLater = DateTime(now.year, now.month + 1, now.day);
    selectedStartDate.value = DateFormat('yyyy-MM-dd').format(now);
    selectedEndDate.value = DateFormat('yyyy-MM-dd').format(oneMonthLater);
  }

  Rx<SavingPlanCalculateResponse.Data?> data = Rx<SavingPlanCalculateResponse.Data?>(null);

  RxDouble goalAmount = 0.0.obs;
  RxDouble currentAmount = 0.0.obs;
  RxString selectedStartDate = ''.obs;
  RxString selectedEndDate = ''.obs;
  RxBool isLoading = false.obs;

  final TextEditingController goalAmountController = TextEditingController();
  final TextEditingController currentAmountController = TextEditingController();

  void clear() {
    goalAmount.value = 0.0;
    currentAmount.value = 0.0;
    goalAmountController.clear();
    currentAmountController.clear();
    // Optionally reset dates to default or leave them as is:
    // final now = DateTime.now();
    // selectedStartDate.value = DateFormat('yyyy-MM-dd').format(now);
    // selectedEndDate.value = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, now.day));
  }

  Future<void> calculate() async {
    isLoading.value = true;
    try {
      final response = await savingPlanCalculateRepository.calculate(
        goalAmount.value,
        currentAmount.value,
        selectedStartDate.value,
        selectedEndDate.value,
      );

      if (response.status == 0) {
        data.value = response.data;

        Get.snackbar(
          "ជោគជ័យ",
          response.message ?? "បានគណនារួចរាល់!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      } else {
        Get.snackbar(
          "បរាជ័យ",
          response.message ?? "បរាជ័យក្នុងការគណនា",
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
