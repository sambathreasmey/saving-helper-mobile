import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeController.theme.value!.firstControlColor!,
            themeController.theme.value!.secondControlColor!
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: themeController.theme.value!.secondControlColor!.withOpacity(0.1),
            blurRadius: 3,
            offset: Offset(0, -3),
          ),
        ],
      ),
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
