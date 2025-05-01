import 'package:flutter/material.dart';
import 'package:saving_helper/controllers/header_controller.dart';
import 'package:saving_helper/repository/header_repository.dart';
import 'package:saving_helper/screen/deposit_saving_screen.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'package:saving_helper/screen/loan_repay_screen.dart';
import 'package:saving_helper/screen/loan_screen.dart';
import 'package:saving_helper/screen/login_screen.dart';
import 'package:get/get.dart';
import 'package:saving_helper/screen/report_screen.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/services/share_storage.dart';

import '../constants/app_color.dart' as app_colors;

class CustomHeader extends StatefulWidget {
  const CustomHeader({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomHeaderState createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {

  final HeaderController controller = Get.put(HeaderController(HeaderRepository(ApiProvider())));
  final ShareStorage shareStorage = ShareStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: app_colors.menu3Color,
                ),
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.savings_outlined, color: Colors.white, size: 20,),
                  onPressed: () {
                    _showModalBottomSheet(context, controller, shareStorage);
                  }
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Obx(() {
                      final user = controller.userInfo.value;
                      final displayName = (user?.fullName?.isNotEmpty == true)
                          ? user?.fullName
                          : (user?.userName?.isNotEmpty == true)
                          ? user?.userName
                          : '';
                      return Text(
                        displayName!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MyBaseFont',
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Obx(() {
                      return Text(
                        controller.userInfo.value?.role ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'MyBaseFont',
                        ),
                      );
                    }
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            spacing: 2,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  // ignore: deprecated_member_use
                  color: Colors.blue.withOpacity(0.2),
                ),
                child: IconButton(
                    icon: Icon(Icons.notifications_active, color: app_colors.baseWhiteColor, size: 16,),
                    onPressed: () {
                      controller.getNotification();
                      _showNotificationDialog(context, controller);
                    }
                ),
              ),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  // ignore: deprecated_member_use
                  color: Colors.blue.withOpacity(0.2),
                ),
                child: IconButton(
                  icon: Icon(Icons.settings, color: app_colors.baseWhiteColor, size: 16,),
                  onPressed: () {
                    _showModalBottomSheet(context, controller, shareStorage);
                  }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showNotificationDialog(BuildContext context, HeaderController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Obx(() => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),  // Rounded corners
        ),
        title: Row(
          children: [
            Icon(Icons.notifications, color: app_colors.baseColor, size: 28),  // Add an icon for the notification
            SizedBox(width: 10),  // Space between the icon and text
            Text(
              'ជូនដំណឹង',
              style: TextStyle(
                color: app_colors.baseColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'MyBaseFont',
              ),
            ),
          ],
        ),
        content: Text(
          controller.notificationMessage.value ?? "No new notifications",  // Display notification message
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'MyBaseFont',
          ),
        ),
        actions: <Widget>[
          // Button to close the dialog
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: app_colors.baseColor,  // Custom button color
              ),
              child: Text(
                'យល់ព្រម',
                style: TextStyle(fontSize: 16, color: app_colors.baseWhiteColor, fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold,),
              ),
            ),
          ),
        ],
      ));
    },
  );
}

void _showModalBottomSheet(BuildContext context, HeaderController controller, ShareStorage shareStorage) {
  final user = controller.userInfo.value;
  final displayName = (user?.fullName?.isNotEmpty == true)
      ? user?.fullName
      : (user?.userName?.isNotEmpty == true)
      ? user?.userName
      : "N/A";

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.only(left: 16.0,  right: 16.0,top: 16.0, bottom: 0.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50], // Light background color
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          children: [
            // User Info Section
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: app_colors.baseColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg'), // Replace with your image URL
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: app_colors.baseWhiteColor,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                        Text(
                          user!.emailAddress ?? 'N/A',
                          style: TextStyle(color: app_colors.subTitleText, fontSize: 12, fontFamily: 'MyBaseFont',), // Grey color for email
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                // Menu Section
                ListTile(
                  leading: Icon(Icons.dashboard_outlined, color: app_colors.baseColor,),
                  title: Text('Dashboard', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont',)),
                  onTap: () {
                    Get.delete<HeaderController>();
                    Get.to(() => HomeScreen());
                    // Perform logout action
                  },
                ),
                // Management Section with Animated Submenu
                ManagementSubMenu(),
                ReportSubMenu(),
                // Logout Section
                ListTile(
                  leading: Icon(Icons.logout, color: app_colors.baseColor,),
                  title: Text('Logout', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont',)),
                  onTap: () {
                    shareStorage.removeUserCredential();
                    shareStorage.removeToken();
                    Get.delete<HeaderController>();
                    Get.to(() => LoginScreen(title: 'Home Screen Title'));
                    // Perform logout action
                  },
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}

class ManagementSubMenu extends StatefulWidget {
  const ManagementSubMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManagementSubMenuState createState() => _ManagementSubMenuState();
}

class _ManagementSubMenuState extends State<ManagementSubMenu> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.science_outlined, color: app_colors.baseColor,),
          title: Text('គ្រប់គ្រង', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont',)),
          trailing: Icon(
            _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: app_colors.baseColor,
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle the submenu
            });
          },
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _isExpanded ? 110 : 0, // Adjust height based on expansion
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                children: [
                  if (_isExpanded) ...[
                    ListTile(
                      leading: Icon(Icons.savings_outlined, color: app_colors.baseColor,),
                      title: Text('បញ្ចូលប្រាក់សន្សំ', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont',)),
                      onTap: () {
                        Get.delete<HeaderController>();
                        Get.to(() => DepositSavingScreen());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.real_estate_agent_outlined, color: app_colors.baseColor),
                      title: Text('បញ្ចូលប្រាក់កម្ចី', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont',)),
                      onTap: () {
                        Get.delete<HeaderController>();
                        Get.to(() => LoanScreen());
                      },
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.currency_exchange_outlined, color: app_colors.baseColor,),
                    //   title: Text('សងប្រាក់កម្ចី', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont',)),
                    //   onTap: () {
                    //     Get.delete<HeaderController>();
                    //     Get.to(() => LoanRepayScreen());
                    //   },
                    // ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//|||||||||||||||||||| report |||||||||||||||||||||
class ReportSubMenu extends StatefulWidget {
  const ReportSubMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportSubMenuState createState() => _ReportSubMenuState();
}

class _ReportSubMenuState extends State<ReportSubMenu> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.account_balance_outlined, color: app_colors.baseColor,),
          title: Text('របាយការណ៍', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont',)),
          trailing: Icon(
            _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: app_colors.baseColor,
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle the submenu
            });
          },
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _isExpanded ? 60 : 0, // Adjust height based on expansion
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                children: [
                  if (_isExpanded) ...[
                    ListTile(
                      leading: Icon(Icons.event_repeat, color: app_colors.baseColor,),
                      title: Text('របាយការណ៍ទូទៅ', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseFont',)),
                      onTap: () {
                        Get.delete<HeaderController>();
                        Get.to(() => ReportScreen());
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}