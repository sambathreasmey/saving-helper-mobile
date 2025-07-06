import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/models/ThemeData.dart';
import 'package:saving_helper/splash_screen.dart';

import '../services/share_storage.dart';

class ThemeController extends GetxController {
  final ShareStorage shareStorage = ShareStorage();

  Rx<ThemeDataModel?> theme = Rx<ThemeDataModel?>(
    ThemeDataModel(themePath: 'assets/images/blur.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
  );

  final List<ThemeDataModel> themes = [
    ThemeDataModel(themePath: 'assets/images/blur.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/linear_01.png', firstControlColor: Colors.greenAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/linear_02.png', firstControlColor: Colors.purpleAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/linear_03.png', firstControlColor: Colors.black, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/linear_04.png', firstControlColor: Colors.lightBlueAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/linear_05.png', firstControlColor: Colors.redAccent, secondControlColor: Colors.purpleAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/nature_01.png', firstControlColor: Colors.green, secondControlColor: Colors.lightBlueAccent, textColor: Colors.black),
    ThemeDataModel(themePath: 'assets/images/nature_02.png', firstControlColor: Colors.lightBlueAccent, secondControlColor: Colors.blueGrey, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/nature_03.png', firstControlColor: Colors.indigo, secondControlColor: Colors.greenAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/nature_04.png', firstControlColor: Colors.deepPurple, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/abstract_01.png', firstControlColor: Colors.black12, secondControlColor: Colors.grey, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/abstract_02.png', firstControlColor: Colors.purpleAccent, secondControlColor: Colors.black45, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/abstract_03.png', firstControlColor: Colors.grey, secondControlColor: Colors.brown, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/abstract_04.png', firstControlColor: Colors.white60, secondControlColor: Colors.brown, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/tree_01.png', firstControlColor: Colors.pink, secondControlColor: Colors.indigoAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/tree_02.png', firstControlColor: Colors.teal, secondControlColor: Colors.green, textColor: Colors.black),
    ThemeDataModel(themePath: 'assets/images/tree_03.png', firstControlColor: Colors.deepOrange, secondControlColor: Colors.orange, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/tree_04.png', firstControlColor: Colors.purple, secondControlColor: Colors.black, textColor: Colors.amberAccent),
    ThemeDataModel(themePath: 'assets/images/tree_05.png', firstControlColor: Colors.indigoAccent, secondControlColor: Colors.cyanAccent, textColor: Colors.pinkAccent),
    ThemeDataModel(themePath: 'assets/images/beach_01.png', firstControlColor: Colors.black, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/beach_02.png', firstControlColor: Colors.pink, secondControlColor: Colors.blue, textColor: Colors.cyanAccent),
    ThemeDataModel(themePath: 'assets/images/beach_03.png', firstControlColor: Colors.brown, secondControlColor: Colors.cyan, textColor: Colors.cyanAccent),
    ThemeDataModel(themePath: 'assets/images/beach_04.png', firstControlColor: Colors.white, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_01.png', firstControlColor: Colors.grey, secondControlColor: Colors.blueGrey, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_02.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.lightBlue, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_03.png', firstControlColor: Colors.deepPurpleAccent, secondControlColor: Colors.blueGrey, textColor: Colors.tealAccent),
    ThemeDataModel(themePath: 'assets/images/couple_04.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_05.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_06.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_07.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_08.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_09.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
    ThemeDataModel(themePath: 'assets/images/couple_10.png', firstControlColor: Colors.pinkAccent, secondControlColor: Colors.blueAccent, textColor: Colors.white),
  ];

  int _currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  /// Change background to next image and save it
  void changeBackground() {
    _currentIndex = (_currentIndex + 1) % themes.length;
    final newTheme = themes[_currentIndex];
    theme.value = newTheme;
    saveTheme(newTheme);
    Get.off(() => SplashScreen());
  }

  /// Save selected theme to SharedPreferences
  Future<void> saveTheme(ThemeDataModel theme) async {
    await shareStorage.saveTheme(theme);
  }

  /// Load theme from SharedPreferences on startup
  Future<void> loadTheme() async {
    final savedTheme = await shareStorage.getTheme();
    if (savedTheme != null && themes.contains(savedTheme)) {
      theme.value = savedTheme;
      _currentIndex = themes.indexOf(savedTheme);
    }
  }
}
