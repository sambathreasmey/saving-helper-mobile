import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/login_controller.dart';
import 'package:saving_helper/constants/app_color.dart' as app_colors;
import 'package:saving_helper/controllers/register_controller.dart';
import 'package:saving_helper/repository/login_repository.dart';
import 'package:saving_helper/repository/register_repository.dart';
import 'package:saving_helper/screen/register_screen.dart';
import 'package:saving_helper/screen/widgets/input_field/TextFieldWidget.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(themeController.theme.value!.themePath!),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 200,),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white, // Slightly transparent background
                    ),
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
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                            // color: app_colors.baseColor.withOpacity(0.11),
                          ),
                          child: Text(
                            'ចូលទៅគណនីរបស់អ្នក',
                            style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600, fontFamily: 'MyBaseFont',),
                          ),
                        ),
                        SizedBox(height: 25), // Add some space between fields
                        Text(
                          'បញ្ចូលឈ្មោះអ្នកប្រើប្រាស់ និងពាក្យសម្ងាត់របស់អ្នកដើម្បីចូល',
                          style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'MyBaseFont',),
                        ),
                        SizedBox(height: 25), // Add some space between fields
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
                                    style: TextStyle(color: app_colors.subTitleText, fontFamily: 'MyBaseFont',),
                                  ), // Label for the checkbox
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: app_colors.loveColor, // Button color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0), // Set the border radius to 15
                                    ),
                                  ),
                                  onPressed: loginController.login,
                                  child: Text('ចូលគណនី', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'MyBaseFont',)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'មិនមានគណនីមែនទេ?',
                                    style: TextStyle(color: app_colors.subTitleText, fontFamily: 'MyBaseFont',),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle registration action
                                      // Navigate to registration page or show registration dialog
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}