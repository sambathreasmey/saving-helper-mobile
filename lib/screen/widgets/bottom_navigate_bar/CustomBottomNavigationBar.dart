import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/screen/deposit_saving_screen.dart';
import 'package:saving_helper/screen/goal_management_screen.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'package:saving_helper/screen/report_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ThemeController themeController;
  final int currentIndex;
  final Function(int) onIndexChanged;

  CustomBottomNavigationBar({
    required this.themeController,
    required this.currentIndex,
    required this.onIndexChanged,
    Key? key,
  }) : super(key: key);

  // Screens for each tab
  final List<Widget> _screens = [
    HomeScreen(),
    ReportScreen(),
    DepositSavingScreen(),
    GoalManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 90,
      alignment: Alignment.center,
      gradient: LinearGradient(
        colors: [
          themeController.theme.value?.firstControlColor?.withOpacity(0.40) ?? Colors.black,
          themeController.theme.value?.secondControlColor?.withOpacity(0.10) ?? Colors.black.withOpacity(0.9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          themeController.theme.value?.firstControlColor?.withOpacity(0.60) ?? Colors.white.withOpacity(0.60),
          themeController.theme.value?.firstControlColor?.withOpacity(0.10) ?? Colors.white.withOpacity(0.60),
          themeController.theme.value?.secondControlColor?.withOpacity(0.05) ?? Colors.white.withOpacity(0.05),
          themeController.theme.value?.secondControlColor?.withOpacity(0.60) ?? Colors.white.withOpacity(0.60),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.39, 0.40, 1.0],
      ),
      blur: 20,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
      borderWidth: 0.95,
      elevation: 4.0,
      shadowColor: themeController.theme.value?.secondControlColor?.withOpacity(0.20) ?? Colors.purple.withOpacity(0.20),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'លំនាំដើម', 0),
            _buildNavItem(Icons.history, 'ប្រវត្តិ', 1),
            _buildNavItem(Icons.savings_outlined, 'បញ្ចលសន្សំ', 2),
            _buildNavItem(Icons.grass_outlined, 'គម្រោង', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        onIndexChanged(index); // Update the current index reactively
        _navigateToTab(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: currentIndex == index
                ? themeController.theme.value!.textColor!
                : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'MyBaseFont',
              fontSize: 10,
              color: currentIndex == index
                  ? themeController.theme.value!.textColor!
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to the selected screen and clear the navigation stack
  void _navigateToTab(int index) {
    Get.offAll(() => _screens[index]); // Use Get.offAll to replace the route
  }
}
