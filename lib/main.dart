// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/screen/login_screen.dart';
import 'package:saving_helper/splash_screen.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'GetX Login Example',
    home: SplashScreen(),
  ));
}