import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/goal_management_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/goal_management_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/screen/widgets/input_field/AmountFieldWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/TextFieldWidget.dart';
import 'package:saving_helper/screen/widgets/label/EditableBoxField.dart';
import 'package:saving_helper/screen/widgets/title/cool_title.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/services/share_storage.dart';
import 'package:saving_helper/theme_screen.dart';

import '../models/responses/login_response.dart' as LoginResponse;

class AccountInformationScreen extends StatefulWidget {

  const AccountInformationScreen({super.key});

  @override
  _AccountInformationScreenState createState() => _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  // final GoalManagementController controller = Get.put(GoalManagementController(GoalManagementRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());
  final ShareStorage shareStorage = ShareStorage();
  late final LoginResponse.Data? user = LoginResponse.Data();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = () {
      if (user == null) return "N/A";
      if (user?.fullName?.isNotEmpty == true) return user?.fullName;
      if (user?.userName?.isNotEmpty == true) return user?.userName!;
      return "N/A";
    }();

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
                    const SizedBox(height: 32),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeController.theme.value?.firstControlColor ?? Colors.black,
                            themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        // border: Border.all(
                        //   color: themeController.theme.value?.textColor ?? Colors.white, // Border color
                        //   width: 1.0,         // Border width
                        // ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: themeController.theme.value?.secondControlColor?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          getInitials('សម្បត្តិ រស្មី'), style: TextStyle(color: themeController.theme.value!.textColor ?? Colors.black, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont', fontSize: 52),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  width: double.infinity,
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
                                child: CoolTitle('ព័ត៌មានគណនី'),
                              ),
                              // _buildBoxField(
                              //   'ឈ្មោះ',
                              //   'សម្បត្តិ រស្មី',
                              //   [
                              //     themeController.theme.value?.firstControlColor ?? Colors.black,
                              //     themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                              //   ],
                              //   themeController.theme.value?.textColor ?? Colors.white,
                              //   onEditPressed: () {
                              //     print('editing');
                              //   },
                              // ),
                              // _buildBoxField(
                              //   'ឈ្មោះអ្នកប្រើប្រាស់',
                              //   'sambathreasmey',
                              //   fontFamily: 'MyBaseEnFont',
                              //   [
                              //     themeController.theme.value?.firstControlColor ?? Colors.black,
                              //     themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                              //   ],
                              //   themeController.theme.value?.textColor ?? Colors.white,
                              // ),
                              // _buildBoxField(
                              //   'អ៊ីមែល',
                              //   'reasmeysambath@gmail.com',
                              //   fontFamily: 'MyBaseEnFont',
                              //   [
                              //     themeController.theme.value?.firstControlColor ?? Colors.black,
                              //     themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                              //   ],
                              //   themeController.theme.value?.textColor ?? Colors.white,
                              // ),
                              // _buildBoxField(
                              //   'សិទ្ធិ',
                              //   'OWNER',
                              //   fontFamily: 'MyBaseEnFont',
                              //   [
                              //     themeController.theme.value?.firstControlColor ?? Colors.black,
                              //     themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                              //   ],
                              //   themeController.theme.value?.textColor ?? Colors.white,
                              // ),
                              // _buildBoxField(
                              //   'លេខសំងាត់',
                              //   '**************',
                              //   fontFamily: 'MyBaseEnFont',
                              //   [
                              //     themeController.theme.value?.firstControlColor ?? Colors.black,
                              //     themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                              //   ],
                              //   themeController.theme.value?.textColor ?? Colors.white,
                              // ),
                              EditableBoxField(
                                label: 'ឈ្មោះ',
                                initialValue: 'សម្បត្តិ រស្មី',
                                colors: [
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                ],
                                labelColor: themeController.theme.value?.textColor ?? Colors.white,
                                onSave: (val) => print("Updated to: $val"),
                              ),
                              EditableBoxField(
                                label: 'ឈ្មោះអ្នកប្រើប្រាស់',
                                initialValue: 'sambathreasmey',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                ],
                                labelColor: themeController.theme.value?.textColor ?? Colors.white,
                              ),
                              EditableBoxField(
                                label: 'អ៊ីមែល',
                                initialValue: 'reasmeysambath@gmail.com',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                ],
                                labelColor: themeController.theme.value?.textColor ?? Colors.white,
                              ),
                              EditableBoxField(
                                label: 'សិទ្ធិ',
                                initialValue: 'OWNER',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                ],
                                labelColor: themeController.theme.value?.textColor ?? Colors.white,
                              ),
                              EditableBoxField(
                                label: 'លេខសំងាត់',
                                initialValue: '**************',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                ],
                                labelColor: themeController.theme.value?.textColor ?? Colors.white,
                              ),
                              EditableBoxField(
                                label: 'លេខគណនី',
                                initialValue: '**************',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                ],
                                labelColor: themeController.theme.value?.textColor ?? Colors.white,
                              ),
                            ],
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