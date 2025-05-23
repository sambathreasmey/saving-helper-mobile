// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'dart:async';

import 'package:saving_helper/screen/login_screen.dart';
import 'package:saving_helper/services/share_storage.dart';
import 'package:saving_helper/theme_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final ThemeController themeController = Get.put(ThemeController());
  final ShareStorage shareStorage = ShareStorage();

  @override
  void initState() {
    super.initState();
    // Background Image
    Timer(Duration(seconds: 1), () {
      checkUserCredential(context);
    });
  }

  Future<void> checkUserCredential(BuildContext context) async {
    final username = await shareStorage.getUserCredential(); // Await the Future
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => username == null || username.isEmpty
            ? LoginScreen(title: 'Saving Helper')
            : HomeScreen(), // Assuming you have a HomeScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Background Image
            Container(
             color: Colors.white,
            ),
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeController.theme.value?.firstControlColor ?? Colors.black,
                    themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.savings_outlined, color: themeController.theme.value?.textColor ?? Colors.white, size: 40,), onPressed: () {  },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Saving Helper',
              style: TextStyle(
                color: themeController.theme.value?.textColor ?? Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}