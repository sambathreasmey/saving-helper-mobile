import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saving_helper/controllers/deposit_saving_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/deposit_saving_repository.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/theme_screen.dart';
import '../constants/app_color.dart' as app_colors;

class DepositSavingScreen extends StatefulWidget {
  const DepositSavingScreen({super.key});

  @override
  _DepositSavingScreenState createState() => _DepositSavingScreenState();
}

class _DepositSavingScreenState extends State<DepositSavingScreen> {
  final DepositSavingController controller =
  Get.put(DepositSavingController(DepositSavingRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CustomHeader(),
                    const SizedBox(height: 16),
                    _buildBreadcrumb(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildAmountField(),
                      const SizedBox(height: 20),
                      _buildCurrencySelector(),
                      const SizedBox(height: 16),
                      _buildDatePicker(),
                      const SizedBox(height: 16),
                      _buildNoteField(),
                      const SizedBox(height: 16),
                      _buildAddToExistingCheckbox(),
                      const SizedBox(height: 16),
                      _buildImageUploadSection(),
                      const SizedBox(height: 12),
                      Obx(() => controller.isUploading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: controller.pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: app_colors.baseColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Pick & Upload Image'),
                      )),
                      showDetectTextFromUpdateImage(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeController.theme.value?.firstControlColor ?? Colors.black,
                    themeController.theme.value?.secondControlColor ?? Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: controller.saveDeposit,
                child: Text('បញ្ចូល', style: TextStyle(color: themeController.theme.value?.textColor ?? Colors.white, fontSize: 16, fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold,)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('គ្រប់គ្រង',
              style: TextStyle(
                  color: themeController.theme.value?.textColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyBaseFont')),
          Row(
            children: [
              Text('គ្រប់គ្រង /',
                  style: TextStyle(
                      color: themeController.theme.value?.textColor ?? Colors.white,
                      fontSize: 9,
                      fontFamily: 'MyBaseFont')),
              Text('បញ្ចូលប្រាក់សន្សំ',
                  style: TextStyle(
                      color: themeController.theme.value?.textColor ?? Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyBaseFont')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: controller.amountController,
      onChanged: (value) => controller.amount.value = value,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration:
      _inputDecoration('ចំនួនទឹកប្រាក់', Icons.account_balance_wallet_outlined),
    );
  }

  Widget _buildCurrencySelector() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => openSelectCategory(),
        );
      },
      child: Obx(() => TextField(
        enabled: false,
        decoration: _inputDecoration(
          controller.selectedCurrency.value.isEmpty
              ? "សូមជ្រើសរើសប្រភេទសាច់ប្រាក់"
              : controller.selectedCurrency.value,
          Icons.arrow_drop_down,
        ),
        style: Theme.of(context).textTheme.titleMedium?.apply(
            fontFamily: 'MyBaseFont', color: app_colors.baseWhiteColor),
      )),
    );
  }

  Widget _buildDatePicker() {
    return Obx(() => GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.selectedDate.value =
              DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: _inputDecoration(
              controller.selectedDate.value.isEmpty
                  ? "ថ្ងៃខែឆ្នាំ"
                  : controller.selectedDate.value,
              Icons.calendar_today),
        ),
      ),
    ));
  }

  Widget _buildNoteField() {
    return TextField(
      controller: controller.transactionDescController,
      onChanged: (value) => controller.transactionDesc.value = value,
      decoration: _inputDecoration('កំណត់ចំណាំ', Icons.note_alt_outlined),
    );
  }

  Widget _buildAddToExistingCheckbox() {
    return Obx(() => CheckboxListTile(
      title: Text('បន្ថែមលើប្រតិបត្តិចាស់ក្នុងថ្ងៃ',
          style: TextStyle(
              color: app_colors.baseWhiteColor,
              fontFamily: 'MyBaseFont')),
      value: controller.isSavingMore.value,
      onChanged: (value) =>
      controller.isSavingMore.value = value ?? false,
    ));
  }

  Widget _buildImageUploadSection() {
    return Obx(() => GestureDetector(
      onTap: controller.pickImage,
      child: controller.selectedImage.value != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(controller.selectedImage.value!.path),
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      )
          : Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined,
                  size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                "ចុចដើម្បីជ្រើសរូបភាព",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget showDetectTextFromUpdateImage() {
    return Obx(() => controller.extractedText.value.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          controller.extractedText.value,
          style:
          const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    )
        : const SizedBox.shrink());
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue)),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: Icon(icon),
    );
  }

  Widget openSelectCategory() {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.1,
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      decoration: BoxDecoration(
        color: app_colors.baseWhiteColor,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16)),
            ),
            child: const Center(child: Text("សូមជ្រើសរើសប្រភេទសាច់ប្រាក់",style: TextStyle(
                color: Colors.white,
                fontFamily: 'MyBaseFont',
              fontSize: 14,
            ),),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.currencyList.length,
              itemBuilder: (_, index) {
                final currency = controller.currencyList[index];
                return InkWell(
                  onTap: () {
                    controller.selectedCurrency.value = currency;
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Text(currency,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
