import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/models/requests/deposit_saving_request.dart';
import 'package:saving_helper/repository/deposit_saving_repository.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'package:saving_helper/services/share_storage.dart';

import 'package:saving_helper/constants/app_color.dart' as app_color;
import 'package:saving_helper/constants/app_global.dart' as app_global;

class LoanController extends GetxController {
  final DepositSavingRepository depositSavingRepository;

  LoanController(this.depositSavingRepository);

  // Reactive variables
  RxString amount = ''.obs;
  RxString transactionDesc = ''.obs;
  RxString selectedCurrency = 'USD'.obs;
  RxList<String> currencyList = ['USD', 'KHR'].obs;
  RxString selectedDate = ''.obs;
  var isLoading = false.obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController transactionDescController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Sync amount.text to amount.value reactively
    amountController.addListener(() {
      amount.value = amountController.text;
    });

    transactionDescController.addListener(() {
      transactionDesc.value = transactionDescController.text;
    });

    selectedDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void onClose() {
    amountController.dispose();
    transactionDescController.dispose();
    super.onClose();
  }

  Future<void> saveLoan() async {
    if (isLoading.value) return; // prevent duplicate tap
    isLoading.value = true; // Start loading
    // Validate input
    if (selectedCurrency.value == 'KHR') {
      isLoading.value = false;
      Get.snackbar("ព័ត៍មានមិនត្រឹមត្រូវ", 'ប្រភេទប្រាក់រៀលមិនទាន់កំណត់នៅឡើយ សូមជ្រើសរើសដុល្លារជំនួស', colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      return;
    }

    if (amount.value.isEmpty) {
      isLoading.value = false;
      Get.snackbar("ព័ត៍មានមិនត្រឹមត្រូវ", 'សូមបញ្ចូលចំនួនទឹកប្រាក់', colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      return;
    }
    if (selectedCurrency.value.isEmpty || selectedDate.value.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Error', 'Please fill in all fields', snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      final shareStorage = ShareStorage();
      final storedUserId = await shareStorage.getUserCredential();
      final groupId = await shareStorage.getGroupId();
      var depositSavingRequest = DepositSavingRequest(
        channelId: app_global.channelId,
        transactionDate: selectedDate.value,
        amount: amount.value,
        transactionDesc: transactionDesc.value,
        userId: storedUserId!,
        currencyType: selectedCurrency.value,
        transactionType: 'loan',
        groupId: groupId!,
      );
      final response = await depositSavingRepository.depositSaving(depositSavingRequest);

      if (response.status == 0) {
        Get.snackbar("ទទួលបានជោគជ័យ", "ខ្ចីប្រាក់ជោគជ័យ", colorText: app_color.background, icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor));
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Login failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveLoanRepay() async {
    // Validate input
    if (selectedCurrency.value == 'KHR') {
      Get.snackbar("ព័ត៍មានមិនត្រឹមត្រូវ", 'ប្រភេទប្រាក់រៀលមិនទាន់កំណត់នៅឡើយ សូមជ្រើសរើសដុល្លារជំនួស', colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      return;
    }

    if (amount.value.isEmpty) {
      Get.snackbar("ព័ត៍មានមិនត្រឹមត្រូវ", 'សូមបញ្ចូលចំនួនទឹកប្រាក់', colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      return;
    }
    if (selectedCurrency.value.isEmpty || selectedDate.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields', snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      final shareStorage = ShareStorage();
      final storedUserId = await shareStorage.getUserCredential();
      final groupId = await shareStorage.getGroupId();
      var depositSavingRequest = DepositSavingRequest(
        channelId: app_global.channelId,
        transactionDate: selectedDate.value,
        amount: amount.value,
        transactionDesc: transactionDesc.value,
        userId: storedUserId!,
        currencyType: selectedCurrency.value,
        transactionType: 'loan_repay',
        groupId: groupId!,
      );
      final response = await depositSavingRepository.depositSaving(depositSavingRequest);

      if (response.status == 0) {
        Get.snackbar("ទទួលបានជោគជ័យ", "សងប្រាក់ជោគជ័យ", colorText: app_color.background, icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor));
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Login failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }

}