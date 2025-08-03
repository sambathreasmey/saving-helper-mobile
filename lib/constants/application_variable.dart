import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ApplicationVariable {
  static Color themeTextColor = Colors.white;
  static Color themeFirstGradientColor = Colors.white;
  static Color themeSecondGradientColor = Colors.white;
  static Color themeFirstBorderColor = Colors.white;
  static Color themeSecondBorderColor = Colors.white;
  static Color themeShadowColor = Colors.white;
  static String themeImage = "assets/images/blur.png";

  static Future<void> vibrate() async {
    if (await Vibration.hasVibrator()) {
      // Pattern: [off, on] where 'on' is the vibration time in milliseconds
      Vibration.vibrate(pattern: [0, 10, 23, 45]);  // Strong vibration pattern
    }
  }
}