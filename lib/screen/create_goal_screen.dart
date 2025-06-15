import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/goal_management_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/goal_management_repository.dart';
import 'package:saving_helper/screen/goal_management_screen.dart';
import 'package:saving_helper/screen/widgets/bread_crumb/DynamicBreadcrumbWidget.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/screen/widgets/input_field/AmountFieldWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/TextFieldWidget.dart';
import 'package:saving_helper/screen/widgets/progress/CircleProgressCompament.dart';
import 'package:saving_helper/screen/widgets/progress/LineProgressComponent.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

import '../constants/app_color.dart' as app_colors;
import '../models/responses/get_goal_response.dart' as GetGoalResponse;

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  _CreateGoalScreenState createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final GoalManagementController controller = Get.put(GoalManagementController(GoalManagementRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

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
                      title: 'បង្កើតគម្រោង',
                      subTitle: 'គ្រប់គ្រង',
                      path: 'គម្រោងសន្សំប្រាក់',
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
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    themeController.theme.value?.firstControlColor ?? Colors.white,
                                    themeController.theme.value?.secondControlColor ?? Colors.white
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                blendMode: BlendMode.srcIn,
                                child: Text(
                                  'បង្កើតគម្រោង',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MyBaseFont',
                                      foreground: Paint()
                                    // ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0),  // Apply the blur to text
                                  ),
                                ),
                              ),
                              TextFieldWidget(
                                controller: controller.goalNameController,
                                required: true,
                                label: 'ឈ្មោះគម្រោង',
                                prefixIcon: Icons.grass_outlined,
                                keyboardType: TextInputType.text,
                              ),
                              AmountFieldWidget(
                                controller: controller.goalAmountController,
                                required: true,
                                label: 'ទំហំសាច់ប្រាក់',
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
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
                                controller.createGoal();
                              },
                              child: Text('បញ្ចូល', style: TextStyle(color: themeController.theme.value?.textColor ?? Colors.white, fontSize: 16, fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold,)),
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
      ),
    );
  }
}