import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/goal_management_controller.dart';
import 'package:saving_helper/controllers/shop/product_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/goal_management_repository.dart';
import 'package:saving_helper/repository/shop/product_repository.dart';
import 'package:saving_helper/screen/widgets/FullScreenLoader.dart';
import 'package:saving_helper/screen/widgets/bread_crumb/DynamicBreadcrumbWidget.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/screen/widgets/input_field/AmountFieldWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/TextFieldWidget.dart';
import 'package:saving_helper/screen/widgets/title/cool_title.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

import '../../models/shop/product_new_feed.dart' as product_new_feed;
import '../widgets/input_field/SelectItemWidget.dart';

class CreateEditProductScreen extends StatefulWidget {
  final product_new_feed.Data? goalToEdit;

  const CreateEditProductScreen({super.key, this.goalToEdit});

  @override
  _CreateEditProductScreenState createState() => _CreateEditProductScreenState();
}

class _CreateEditProductScreenState extends State<CreateEditProductScreen> {
  final ProductController controller = Get.put(ProductController(ProductRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Delay the controller initialization until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized && widget.goalToEdit != null) {
        controller.initializeWithGoal(widget.goalToEdit!);
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.goalToEdit != null;
    final screenTitle = isEditMode ? 'កែប្រែទំនិញ' : 'បង្កើតទំនិញ';
    final buttonLabel = isEditMode ? 'កែប្រែ' : 'បង្កើត';
    return ThemedScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:
        Stack(
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
                          title: screenTitle,
                          subTitle: 'គ្រប់គ្រង',
                          path: 'គ្រប់គ្រងទំនិញ',
                          textColor: themeController.theme.value?.textColor ?? Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                spacing: 18,
                                children: [
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 400),
                                    opacity: 1.0,
                                    child: CoolTitle(screenTitle),
                                  ),
                                  TextFieldWidget(
                                    controller: controller.nameController,
                                    required: true,
                                    label: 'ឈ្មោះទំនិញ',
                                    prefixIcon: Icons.shopify,
                                    keyboardType: TextInputType.text,
                                  ),
                                  AmountFieldWidget(
                                    prefixIcon: Icons.monetization_on_rounded,
                                    controller: controller.priceController,
                                    required: true,
                                    label: 'តម្លៃ',
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                  ),
                                  SelectItemWidget(
                                    title: 'សូមជ្រើសរើសប្រភេទសាច់ប្រាក់',
                                    itemList: controller.currencyList,  // Pass the list of currencies
                                    selectedCurrency: controller.selectedCurrency, // Pass the reactive selected currency
                                    labelText: 'ប្រភេទសាច់ប្រាក់',
                                    hintText: 'សូមជ្រើសរើសប្រភេទសាច់ប្រាក់',
                                    prefixIcon: Icons.price_change,
                                    suffixIcon: Icons.arrow_drop_down,
                                  ),
                                  TextFieldWidget(
                                    controller: controller.imageController,
                                    required: true,
                                    label: 'រូបភាព URL',
                                    prefixIcon: Icons.image,
                                    keyboardType: TextInputType.text,
                                  ),
                                  TextFieldWidget(
                                    controller: controller.descController,
                                    label: 'ពិពណ៌នា',
                                    prefixIcon: Icons.description,
                                    keyboardType: TextInputType.text,
                                  ),
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
                                  onPressed: () {
                                    // controller.submitGoal();
                                  },
                                  child: Text(
                                    buttonLabel,
                                    style: TextStyle(
                                      color: themeController.theme.value?.textColor ?? Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'MyBaseFont',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
          ]
        ),
      ),
    );
  }
}