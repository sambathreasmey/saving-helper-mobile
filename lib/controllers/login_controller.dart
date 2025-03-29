import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/repository/login_repository.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'package:saving_helper/constants/app_color.dart' as app_color;
import 'package:saving_helper/services/share_storage.dart';

class LoginController extends GetxController {
  final LoginRepository loginRepository;

  LoginController(this.loginRepository);

  final userController = TextEditingController();
  final passController = TextEditingController();

  final ShareStorage shareStorage = ShareStorage();

  Future<void> login() async {
    try {
      final response = await loginRepository.login(
        userController.text,
        passController.text,
      );

      // final response = await loginRepository.login(
      //   'reasmeysambath',
      //   '123',
      // );

      if (response.status == 0) {

        // Save userId using ShareStorage
        final String? userName = response.data?.userName;
        await shareStorage.saveUserCredential(userName!);

        Get.snackbar("ទទួលបានជោគជ័យ", response.message ?? "Login successful", colorText: app_color.background, icon: Icon(Icons.sentiment_satisfied_outlined, color: app_color.baseWhiteColor));
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar("បរាជ័យ", response.message ?? "Login failed", colorText: app_color.background, icon: Icon(Icons.sentiment_dissatisfied_outlined, color: app_color.baseWhiteColor));
      }
    } catch (e) {
      Get.snackbar("ប្រព័ន្ធមានបញ្ហា", e.toString(), colorText: app_color.background, icon: Icon(Icons.warning_amber_sharp, color: app_color.baseWhiteColor));
    }
  }
}