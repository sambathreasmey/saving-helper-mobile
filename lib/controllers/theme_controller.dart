import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/share_storage.dart';

class ThemeController extends GetxController {
  final RxString backgroundImage = 'assets/images/blur.png'.obs;
  final ShareStorage shareStorage = ShareStorage();

  final List<String> backgroundImages = [
    'assets/images/blur.png',
    'assets/images/linear_01.png',
    'assets/images/linear_02.png',
    'assets/images/linear_03.png',
    'assets/images/linear_04.png',
    'assets/images/linear_05.png',
    'assets/images/nature_01.png',
    'assets/images/nature_02.png',
    'assets/images/nature_03.png',
    'assets/images/nature_04.png',
    'assets/images/abstract_01.png',
    'assets/images/abstract_02.png',
    'assets/images/abstract_03.png',
    'assets/images/abstract_04.png',
    'assets/images/tree_01.png',
    'assets/images/tree_02.png',
    'assets/images/tree_03.png',
    'assets/images/tree_04.png',
    'assets/images/tree_05.png',
    'assets/images/beach_01.png',
    'assets/images/beach_02.png',
    'assets/images/beach_03.png',
    'assets/images/beach_04.png',
    'assets/images/couple_01.png',
    'assets/images/couple_02.png',
    'assets/images/couple_03.png',
    'assets/images/couple_04.png',
    'assets/images/couple_05.png',
    'assets/images/couple_06.png',
    'assets/images/couple_07.png',
    'assets/images/couple_08.png',
    'assets/images/couple_09.png',
    'assets/images/couple_10.png',
  ];

  int _currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  /// Change background to next image and save it
  void changeBackground() {
    _currentIndex = (_currentIndex + 1) % backgroundImages.length;
    final newTheme = backgroundImages[_currentIndex];
    backgroundImage.value = newTheme;
    saveTheme(newTheme);
  }

  /// Save selected theme to SharedPreferences
  Future<void> saveTheme(String themePath) async {
    await shareStorage.saveTheme(themePath);
  }

  /// Load theme from SharedPreferences on startup
  Future<void> loadTheme() async {
    final savedTheme = await shareStorage.getTheme();
    if (savedTheme != null && backgroundImages.contains(savedTheme)) {
      backgroundImage.value = savedTheme;
      _currentIndex = backgroundImages.indexOf(savedTheme);
    }
  }
}
