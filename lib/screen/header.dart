import 'package:flutter/material.dart';
import 'package:saving_helper/controllers/header_controller.dart';
import 'package:saving_helper/controllers/home_screen_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/header_repository.dart';
import 'package:saving_helper/screen/deposit_saving_screen.dart';
import 'package:saving_helper/screen/home_screen.dart';
import 'package:saving_helper/screen/loan_screen.dart';
import 'package:saving_helper/screen/login_screen.dart';
import 'package:get/get.dart';
import 'package:saving_helper/screen/report_screen.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/services/share_storage.dart';
import 'package:saving_helper/splash_screen.dart';

import '../constants/app_color.dart' as app_colors;
import 'animated_Invite_banner.dart';

class CustomHeader extends StatefulWidget {
  const CustomHeader({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomHeaderState createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {

  final HeaderController controller = Get.put(HeaderController(HeaderRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());
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
                      final userInfo = controller.userInfo.value;
                      final role = userInfo?.roles?.isNotEmpty == true ? userInfo!.roles!.first : '';

                      return Text(
                        role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'MyBaseEnFont',
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          Row(
            spacing: 2,
            children: [
              _buildMoneyBox(Icons.mode_night_outlined, Colors.lightBlueAccent, Colors.blue, height: 30,
                onTap: () {
                  themeController.changeBackground();
              },),
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
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Obx(() {
        if (controller.isLoadingUserInfo.value) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          );
        }

        final user = controller.userInfo.value;
        final displayName = () {
          if (user == null) return "N/A";
          if (user.fullName?.isNotEmpty == true) return user.fullName!;
          if (user.userName?.isNotEmpty == true) return user.userName!;
          return "N/A";
        }();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            children: [
              AnimatedInviteBanner(),

              SizedBox(height: 8),

              // Profile Section
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'MyBaseFont',
                                  ),
                                ),
                                Text(
                                  user?.emailAddress ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'MyBaseEnFont',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.greenAccent, Colors.blueAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orangeAccent.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    final groups = user?.groups ?? [];

                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        'ជ្រើសរើសក្រុម',
                                        style: TextStyle(fontFamily: 'MyBaseFont', fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      content: groups.isEmpty
                                          ? Text('No groups available', style: TextStyle(fontFamily: 'MyBaseFont'))
                                          : SizedBox(
                                        width: double.maxFinite,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: groups.length,
                                          separatorBuilder: (_, __) => SizedBox(height: 12),
                                          itemBuilder: (context, index) {
                                            final group = groups[index];
                                            final groupName = group.groupName ?? 'Unnamed Group';
                                            final isSelected = group.groupId == controller.currentGroupId.value;

                                            return InkWell(
                                              onTap: () {
                                                controller.switchGroup(group.groupId!);
                                                Get.to(() => SplashScreen());
                                              },
                                              borderRadius: BorderRadius.circular(16),
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16),
                                                  color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.grey[100],
                                                  border: isSelected
                                                      ? Border.all(color: Colors.blueAccent, width: 2)
                                                      : Border.all(color: Colors.grey[300]!),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.group,
                                                      color: isSelected ? Colors.blueAccent : Colors.grey[700],
                                                    ),
                                                    SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        groupName,
                                                        style: TextStyle(
                                                          fontFamily: 'MyBaseFont',
                                                          fontSize: 14,
                                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                          color: isSelected ? Colors.blueAccent : Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(Icons.check_circle, color: Colors.blueAccent, size: 20),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(dialogContext).pop(),
                                          child: Text(
                                            'បោះបង់',
                                            style: TextStyle(fontFamily: 'MyBaseFont', color: Colors.grey[700], fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Icon(
                                Icons.autorenew,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Navigation Menu
              Text("Navigation", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'MyBaseEnFont')),
              SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.dashboard_outlined, color: app_colors.baseColor),
                title: Text('Dashboard', style: TextStyle(color: app_colors.baseColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseEnFont')),
                onTap: () {
                  Get.delete<HeaderController>();
                  Get.to(() => HomeScreen());
                },
              ),

              ManagementSubMenu(),
              ReportSubMenu(),

              // Logout
              SizedBox(height: 24),
              Divider(thickness: 1),
              ListTile(
                leading: Icon(Icons.logout, color: app_colors.baseColor),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: app_colors.baseColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MyBaseEnFont',
                  ),
                ),
                onTap: () {
                  shareStorage.removeUserCredential();
                  shareStorage.removeToken();
                  shareStorage.removeGroupId();
                  Get.delete<HeaderController>();
                  Get.to(() => LoginScreen(title: 'Home Screen Title'));
                },
              ),
            ],
          ),
        );
      });
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

Widget _buildMoneyBox(
    IconData icon,
    Color color1,
    Color color2, {
      double height = 40,
      VoidCallback? onTap, // 👈 added callback
    }) {
  return GestureDetector(
    onTap: onTap, // 👈 use the callback when tapped
    child: Container(
      height: height,
      width: 30,
      padding: EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            color1.withOpacity(0.6),
            color2.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color2.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 18,
      ),
    ),
  );
}

