import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/constants/application_variable.dart';
import 'package:saving_helper/repository/account_repository.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/screen/widgets/label/EditableBoxField.dart';
import 'package:saving_helper/screen/widgets/title/cool_title.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

import '../controllers/account_information_controller.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  _AccountInformationScreenState createState() => _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  final AccountInformationController controller =
  Get.put(AccountInformationController(AccountRepository(ApiProvider())));

  String getInitials(String? name) {
    final n = (name ?? '').trim();
    if (n.isEmpty) return 'U';
    final parts = n.split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Obx(() {
                      final displayName = controller.displayFullName;
                      return Column(
                        children: [
                          const CustomHeader(),
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
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: ApplicationVariable.themeSecondGradientColor,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              getInitials(displayName),
                              style: TextStyle(
                                color: ApplicationVariable.themeTextColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyBaseFont',
                                fontSize: 52,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Obx(() {
                          final u = controller.user.value;
                          final displayName = controller.user.value?.fullName;
                          return Column(
                            spacing: 18,
                            children: [
                              const AnimatedOpacity(
                                duration: Duration(milliseconds: 400),
                                opacity: 1.0,
                                child: CoolTitle('ព័ត៌មានគណនី'),
                              ),
                              // Full name (dynamic)
                              EditableBoxField(
                                label: 'ឈ្មោះ',
                                initialValue: displayName!,
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor,
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                                onSave: (val) {
                                  ApplicationVariable.vibrate();
                                  controller.updateFullName(val);
                                }, readOnly: false,
                              ),
                              // Username (display only here; wire update if you add API)
                              EditableBoxField(
                                label: 'ឈ្មោះអ្នកប្រើប្រាស់',
                                initialValue: u?.userName ?? '',
                                fontFamily: 'MyBaseEnFont',
                                readOnly: true,
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                              ),
                              // Email (display only here; wire update if you add API)
                              EditableBoxField(
                                label: 'អ៊ីមែល',
                                initialValue: u?.email ?? '',
                                fontFamily: 'MyBaseEnFont',
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                                onSave: (val) {
                                  ApplicationVariable.vibrate();
                                  controller.updateEmail(val);
                                }, readOnly: false,
                              ),
                              // Role (display-only placeholder)
                              EditableBoxField(
                                label: 'សិទ្ធិ',
                                initialValue: 'OWNER',
                                fontFamily: 'MyBaseEnFont',
                                readOnly: true,
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                              ),
                              // Password (write-only; skip update here unless you add API)
                              EditableBoxField(
                                label: 'លេខសំងាត់',
                                initialValue: '**************',
                                fontFamily: 'MyBaseEnFont',
                                readOnly: true,
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                              ),
                              // Account No. (display-only)
                              EditableBoxField(
                                label: 'លេខគណនី',
                                initialValue: '**************',
                                fontFamily: 'MyBaseEnFont',
                                readOnly: true,
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor
                                ],
                                labelColor: ApplicationVariable.themeTextColor,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),

              // Loading overlay
              Obx(() => controller.isLoading.value
                  ? Container(
                color: Colors.black26,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}