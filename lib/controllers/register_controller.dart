import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/repository/register_repository.dart';
import 'package:saving_helper/constants/app_color.dart' as app_color;
import 'package:saving_helper/screen/login_screen.dart';

import '../models/requests/register_request.dart';

class RegisterController extends GetxController {
  final RegisterRepository registerRepository;

  RegisterController(this.registerRepository);

  final fullName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> login() async {
    try {
      final request = RegisterRequest(
        fullName: fullName.text,
        userName: userName.text,
        email: email.text,
        password: password.text,
      );
      final response = await registerRepository.register(request);

      if (response.status == 0) {
        Get.snackbar("ជោគជ័យ", response.message ?? "Register successful", colorText: app_color.background, icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor));
        Get.off(() => LoginScreen(title: '',));
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Register failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }
}