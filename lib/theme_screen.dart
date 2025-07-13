import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/screen/widgets/bottom_navigate_bar/CustomBottomNavigationBar.dart';
import 'controllers/theme_controller.dart';
import 'package:saving_helper/screen/widgets/bottom_navigate_bar/TabNavController.dart';

class ThemedScaffold extends StatefulWidget {
  final Widget child;
  const ThemedScaffold({super.key, required this.child});

  @override
  _ThemedScaffoldState createState() => _ThemedScaffoldState();
}

class _ThemedScaffoldState extends State<ThemedScaffold> {
  final TabNavController _tabController = Get.put(TabNavController());

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        themeController: themeController,
        currentIndex: _tabController.currentIndex.value,
        onIndexChanged: (index) {
          // Update the current index reactively
          _tabController.updateIndex(index);
        },
      ),
      extendBody: true,
      body: Obx(() => Stack(
        children: [
          // Dynamic Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(themeController.theme.value!.themePath!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Main content
          widget.child,
        ],
      )),
    );
  }
}