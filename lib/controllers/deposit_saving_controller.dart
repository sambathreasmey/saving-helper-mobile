import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/models/requests/deposit_saving_request.dart';
import 'package:saving_helper/repository/deposit_saving_repository.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'package:saving_helper/services/share_storage.dart';

import 'package:saving_helper/constants/app_color.dart' as app_color;
import 'package:saving_helper/constants/app_global.dart' as app_global;

class DepositSavingController extends GetxController {
  final DepositSavingRepository depositSavingRepository;

  DepositSavingController(this.depositSavingRepository) {
    selectedDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Reactive variables
  RxString amount = ''.obs;
  RxString transactionDesc = 'សន្សំប្រាក់'.obs;
  RxString selectedCurrency = 'USD'.obs;
  RxList<String> currencyList = ['USD', 'KHR'].obs;
  RxString selectedDate = ''.obs;
  RxBool isSavingMore = false.obs;
  RxBool isUploading = false.obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController transactionDescController = TextEditingController();

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  Rxn<XFile> selectedImage = Rxn<XFile>();
  RxString extractedText = ''.obs;

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = picked;

      // Call upload immediately
      await uploadSelectedImage();
    }
  }

  Future<void> uploadSelectedImage() async {
    if (selectedImage.value == null) return;

    try {
      isUploading.value = true;

      final file = File(selectedImage.value!.path);
      print("call to upload image >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      final result = await depositSavingRepository.uploadDocumentImage(file);

      Get.snackbar("Upload Success", result.message ?? "Document uploaded");
    } catch (e) {
      print("Upload error: $e");
      Get.snackbar("Upload Failed", e.toString());
    } finally {
      isUploading.value = false;
    }
  }


  @override
  void onClose() {
    amountController.dispose();
    transactionDescController.dispose();
    super.onClose();
  }

  // Method to save the deposit
  Future<void> saveDeposit() async {
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
        transactionType: isSavingMore.value ? 'saving_deposit_more' : 'saving_deposit',
        groupId: groupId!,
      );
      final response = await depositSavingRepository.depositSaving(depositSavingRequest);

      if (response.status == 0) {
        Get.snackbar("ទទួលបានជោគជ័យ", response.message ?? "Login successful", colorText: app_color.background, icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor));
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Login failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }

}