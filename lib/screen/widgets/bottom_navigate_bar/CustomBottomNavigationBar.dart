import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:saving_helper/constants/application_variable.dart';
import 'package:saving_helper/screen/deposit_saving_screen.dart';
import 'package:saving_helper/screen/goal_management_screen.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'package:saving_helper/screen/report_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  CustomBottomNavigationBar({
    required this.currentIndex, // Pass Rx<int> directly here
    required this.onIndexChanged,
    super.key,
  });

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
          ApplicationVariable.themeFirstGradientColor.withOpacity(0.40),
          ApplicationVariable.themeSecondGradientColor.withOpacity(0.10),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          ApplicationVariable.themeFirstBorderColor.withOpacity(0.60),
          ApplicationVariable.themeFirstBorderColor.withOpacity(0.10),
          ApplicationVariable.themeSecondBorderColor.withOpacity(0.05),
          ApplicationVariable.themeSecondBorderColor.withOpacity(0.60),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.39, 0.40, 1.0],
      ),
      blur: 30,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
      borderWidth: 0.0,
      elevation: 4.0,
      shadowColor: ApplicationVariable.themeSecondGradientColor.withOpacity(0.20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'លំនាំដើម', 0),
            _buildNavItem(Icons.history, 'ប្រវត្តិ', 1),
            _buildNavItem(Icons.savings_outlined, 'បញ្ចលសន្សំ', 2),
            _buildNavItem(Icons.grass_outlined, 'គម្រោង', 3),
          ],
        ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        ApplicationVariable.vibrate();
        if (currentIndex != index) {
          onIndexChanged(index); // Update the index reactively
          _navigateToTab(index); // Only navigate when it's a new tab
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: currentIndex == index
                ? ApplicationVariable.themeTextColor
                : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'MyBaseFont',
              fontSize: 10,
              color: currentIndex == index
                  ? ApplicationVariable.themeTextColor
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
