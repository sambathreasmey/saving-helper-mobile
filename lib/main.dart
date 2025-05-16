// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/firebase_options.dart';
import 'package:saving_helper/services/firebase_api.dart';
import 'package:saving_helper/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  Get.put(ThemeController());
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'GetX Login Example',
    home: SplashScreen(),
  ));
}