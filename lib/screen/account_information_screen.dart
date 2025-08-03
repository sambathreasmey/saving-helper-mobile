import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/constants/application_variable.dart';
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
                            ApplicationVariable.themeFirstGradientColor,
                            ApplicationVariable.themeSecondGradientColor
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
                            color: ApplicationVariable.themeSecondGradientColor,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          getInitials('សម្បត្តិ រស្មី'), style: TextStyle(color: ApplicationVariable.themeTextColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont', fontSize: 52),
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
                              EditableBoxField(
                                label: 'ឈ្មោះ',
                                initialValue: 'សម្បត្តិ រស្មី',
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor,
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                                onSave: (val) => {ApplicationVariable.vibrate(), print("Updated to: $val")},
                              ),
                              EditableBoxField(
                                label: 'ឈ្មោះអ្នកប្រើប្រាស់',
                                initialValue: 'sambathreasmey',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                              ),
                              EditableBoxField(
                                label: 'អ៊ីមែល',
                                initialValue: 'reasmeysambath@gmail.com',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                              ),
                              EditableBoxField(
                                label: 'សិទ្ធិ',
                                initialValue: 'OWNER',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                              ),
                              EditableBoxField(
                                label: 'លេខសំងាត់',
                                initialValue: '**************',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                              ),
                              EditableBoxField(
                                label: 'លេខគណនី',
                                initialValue: '**************',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
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