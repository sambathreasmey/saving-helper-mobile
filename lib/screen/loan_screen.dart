import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/loan_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/deposit_saving_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/screen/widgets/FullScreenLoader.dart';
import 'package:saving_helper/screen/widgets/bread_crumb/DynamicBreadcrumbWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/AmountFieldWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/DatePickerWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/SelectItemWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/TextFieldWidget.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final LoanController controller = Get.put(
    LoanController(DepositSavingRepository(ApiProvider())),
  );
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SafeArea(
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
                          path: 'បញ្ចូលប្រាក់កម្ចី',
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
                          AmountFieldWidget(
                            controller: controller.amountController,
                            required: true,
                            label: 'ទំហំសាច់ប្រាក់',
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ),
                          const SizedBox(height: 16),
                          SelectItemWidget(
                            title: 'សូមជ្រើសរើសប្រភេទសាច់ប្រាក់',
                            itemList: controller.currencyList,  // Pass the list of currencies
                            selectedCurrency: controller.selectedCurrency, // Pass the reactive selected currency
                            labelText: 'ប្រភេទសាច់ប្រាក់',
                            hintText: 'សូមជ្រើសរើសប្រភេទសាច់ប្រាក់',
                            prefixIcon: Icons.monetization_on,
                            suffixIcon: Icons.arrow_drop_down,
                          ),
                          const SizedBox(height: 16),
                          DatePickerWidget(
                            selectedDate: controller.selectedDate,
                            firstControlColor: themeController.theme.value?.firstControlColor ?? Colors.black,
                            secondControlColor: themeController.theme.value?.secondControlColor ?? Colors.black,
                            textColor: themeController.theme.value?.textColor ?? Colors.white,
                          ),
                          const SizedBox(height: 16),
                          TextFieldWidget(
                            controller: controller.transactionDescController,
                            required: true,
                            label: 'មូលហេតុ',
                            prefixIcon: Icons.note_alt_rounded,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                          onPressed: controller.saveLoan,
                          child: Text('បញ្ចូល', style: TextStyle(color: themeController.theme.value!.textColor ?? Colors.black, fontSize: 16, fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold,)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 👇 Use FullScreenLoader here
            Obx(() => FullScreenLoader(
              isLoading: controller.isLoading.value,
              loadingText: 'សូមមេត្តារងចាំ',
              glowColors: [
                themeController.theme.value?.firstControlColor ?? Colors.black,
                themeController.theme.value?.secondControlColor ?? Colors.black],
            )),
          ],
        ),
      ),
    );
  }
}