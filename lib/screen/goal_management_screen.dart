import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/deposit_saving_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/deposit_saving_repository.dart';
import 'package:saving_helper/screen/widgets/bread_crumb/DynamicBreadcrumbWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/AmountFieldWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/DatePickerWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/SelectItemWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/TextFieldWidget.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/theme_screen.dart';

class GoalManagementScreen extends StatefulWidget {
  const GoalManagementScreen({super.key});

  @override
  _GoalManagementScreenState createState() => _GoalManagementScreenState();
}

class _GoalManagementScreenState extends State<GoalManagementScreen> {
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
                    DynamicBreadcrumbWidget(
                      title: 'គ្រប់គ្រង',
                      subTitle: 'គ្រប់គ្រង',
                      path: 'គម្រោងសន្សំប្រាក់',
                      textColor: themeController.theme.value?.textColor ?? Colors.white,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TextFieldWidget(
                          controller: controller.transactionDescController,
                          required: true,
                          label: 'ឈ្មោះគម្រោង',
                          prefixIcon: Icons.grass_outlined,
                          keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      AmountFieldWidget(
                        controller: controller.amountController,
                        required: true,
                        prefixIcon: Icons.monetization_on_outlined,
                        label: 'ទំហំសាច់ប្រាក់',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ),
                      // const SizedBox(height: 20),
                      // SelectItemWidget(
                      //   title: 'សូមជ្រើសរើសប្រភេទសាច់ប្រាក់',
                      //   itemList: controller.currencyList,  // Pass the list of currencies
                      //   selectedCurrency: controller.selectedCurrency, // Pass the reactive selected currency
                      //   labelText: 'ប្រភេទសាច់ប្រាក់',
                      //   hintText: 'សូមជ្រើសរើសប្រភេទសាច់ប្រាក់',
                      //   prefixIcon: Icons.monetization_on,
                      //   suffixIcon: Icons.arrow_drop_down,
                      // ),
                      // const SizedBox(height: 16),
                      // DatePickerWidget(
                      //   selectedDate: controller.selectedDate,
                      //   firstControlColor: themeController.theme.value?.firstControlColor ?? Colors.black,
                      //   secondControlColor: themeController.theme.value?.secondControlColor ?? Colors.black,
                      //   textColor: themeController.theme.value?.textColor ?? Colors.white,
                      // ),
                      // const SizedBox(height: 16),
                      // TextFieldWidget(
                      //   controller: controller.transactionDescController,
                      //   label: 'កំណត់ចំណាំ',
                      //   prefixIcon: Icons.note_alt_rounded,
                      //   keyboardType: TextInputType.text,
                      // ),
                      // const SizedBox(height: 16),
                      // _buildAddToExistingCheckbox(),
                      // const SizedBox(height: 16),
                      // _buildImageUploadSection(),
                      // const SizedBox(height: 12),
                      // showDetectTextFromUpdateImage(),
                      // const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              //   child: SizedBox(
              //     width: double.infinity,
              //     height: 50,
              //     child: Container(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [
              //             themeController.theme.value?.firstControlColor ?? Colors.black,
              //             themeController.theme.value?.secondControlColor ?? Colors.black,
              //           ],
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //         ),
              //         borderRadius: BorderRadius.circular(20),
              //         boxShadow: [
              //           BoxShadow(
              //             color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
              //             blurRadius: 6,
              //             offset: Offset(0, 2),
              //           ),
              //         ],
              //       ),
              //       child: TextButton(
              //         onPressed: controller.saveDeposit,
              //         child: Text('បញ្ចូល', style: TextStyle(color: themeController.theme.value?.textColor ?? Colors.white, fontSize: 16, fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold,)),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildAddToExistingCheckbox() {
    return Obx(() => GestureDetector(
      onTap: () {
        controller.isSavingMore.value = !(controller.isSavingMore.value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Modern Radio Button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: controller.isSavingMore.value
                    ? themeController.theme.value?.secondControlColor ?? Colors.black
                    : Colors.transparent,
                border: Border.all(
                  color: controller.isSavingMore.value
                      ? themeController.theme.value?.secondControlColor ?? Colors.black
                      : Colors.grey.withOpacity(0.4),
                  width: 2,
                ),
                shape: BoxShape.circle, // Circular shape for the radio button
              ),
              child: controller.isSavingMore.value
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              )
                  : null,
            ),
            const SizedBox(width: 12),
            const Text(
              'បន្ថែមលើប្រតិបត្ដិចាស់ក្នុងថ្ងៃ',
              style: TextStyle(
                fontFamily: 'MyBaseFont',
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ));
  }


}
