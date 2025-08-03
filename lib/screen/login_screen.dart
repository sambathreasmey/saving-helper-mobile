import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:saving_helper/controllers/login_controller.dart';
import 'package:saving_helper/constants/app_color.dart' as app_colors;
import 'package:saving_helper/controllers/register_controller.dart';
import 'package:saving_helper/repository/login_repository.dart';
import 'package:saving_helper/repository/register_repository.dart';
import 'package:saving_helper/screen/register_screen.dart';
import 'package:saving_helper/screen/widgets/button/base_button.dart';
import 'package:saving_helper/screen/widgets/input_field/TextFieldWidget.dart';
import 'package:saving_helper/screen/widgets/title/cool_title.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

import '../constants/application_variable.dart';
import '../controllers/theme_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});
  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController loginController;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loginController = Get.put(LoginController(LoginRepository(ApiProvider())));
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures the body resizes when keyboard appears
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside of text fields
        },
        child: Stack(  // Use a Stack to keep background fixed and the content scrollable
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(themeController.theme.value!.themePath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            // Scrollable Content
            SingleChildScrollView(  // Ensure only the content scrolls
              child: Column(
                children: [
                  SizedBox(height: 200),  // To give some space at the top for the title
                  GlassContainer(
                    height: 470,
                    alignment: Alignment.center,
                    gradient: LinearGradient(
                      colors: [
                        ApplicationVariable.themeFirstGradientColor.withOpacity(0.40),
                        ApplicationVariable.themeSecondGradientColor.withOpacity(0.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderGradient: LinearGradient(
                      colors: [
                        ApplicationVariable.themeFirstBorderColor.withOpacity(0.60),
                        ApplicationVariable.themeFirstBorderColor.withOpacity(0.10),
                        ApplicationVariable.themeSecondBorderColor.withOpacity(0.05),
                        ApplicationVariable.themeSecondBorderColor.withOpacity(0.60),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.39, 0.40, 1.0],
                    ),
                    blur: 20,
                    borderRadius: BorderRadius.circular(24.0),
                    borderWidth: 0.95,
                    elevation: 4.0,
                    shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: CoolTitle(
                            'ចូលទៅគណនីរបស់អ្នក',
                          ),
                        ),
                        SizedBox(height: 25),  // Add space between fields
                        Text(
                          'បញ្ចូលឈ្មោះអ្នកប្រើប្រាស់ និងពាក្យសម្ងាត់របស់អ្នកដើម្បីចូល',
                          style: TextStyle(color: ApplicationVariable.themeTextColor, fontSize: 14, fontFamily: 'MyBaseFont',),
                        ),
                        SizedBox(height: 25),  // Add space between fields
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          child: Column(
                            spacing: 16,
                            children: [
                              TextFieldWidget(
                                controller: loginController.userController,
                                required: true,
                                label: 'ឈ្មោះអ្នកប្រើប្រាស់',
                                prefixIcon: Icons.person,
                                keyboardType: TextInputType.text,
                              ),
                              TextFieldWidget(
                                isPassword: true,
                                controller: loginController.passController,
                                required: true,
                                label: 'ពាក្យសម្ងាត់',
                                prefixIcon: Icons.lock,
                                keyboardType: TextInputType.text,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isChecked = !_isChecked; // Toggle checkbox state
                                      });
                                    },
                                    child: Container(
                                      width: 18.0,
                                      height: 18.0,
                                      decoration: BoxDecoration(
                                        color: _isChecked ? app_colors.baseColor : Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0), // Rounded corners
                                      ),
                                      child: _isChecked
                                          ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16.0,
                                      )
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 8.0), // Space between checkbox and label
                                  Text(
                                    'ចងចាំពេលក្រោយ',
                                    style: TextStyle(color: ApplicationVariable.themeTextColor, fontFamily: 'MyBaseFont',),
                                  ), // Label for the checkbox
                                ],
                              ),
                              BaseButtonWidget(label: 'ចូលគណនី', onPressed: loginController.login, height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'មិនមានគណនីមែនទេ?',
                                    style: TextStyle(color: ApplicationVariable.themeTextColor, fontFamily: 'MyBaseFont',),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle registration action
                                      if (kDebugMode) {
                                        print('Navigate to registration page');
                                      }
                                    },
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => RegisterScreen(RegisterController(RegisterRepository(ApiProvider())), title: '',));
                                      },
                                      child: Text(
                                        'បង្កើតគណនី',
                                        style: TextStyle(color: app_colors.loveColor, fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
