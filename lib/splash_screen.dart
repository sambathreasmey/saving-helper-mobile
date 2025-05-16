// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'dart:async';

import 'package:saving_helper/screen/login_screen.dart';
import 'package:saving_helper/services/share_storage.dart';
import 'package:saving_helper/theme_screen.dart';

import 'constants/app_color.dart' as app_colors;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final ShareStorage shareStorage = ShareStorage();

  @override
  void initState() {
    super.initState();
    // Background Image
    Timer(Duration(seconds: 2), () {
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
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: app_colors.menu3Color,
              ),
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.savings_outlined, color: Colors.white, size: 40,), onPressed: () {  },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Saving Helper',
              style: TextStyle(
                color: Colors.white,
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