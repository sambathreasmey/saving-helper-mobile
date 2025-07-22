
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/constants/application_variable.dart';
import 'package:saving_helper/controllers/header_controller.dart';
import 'package:saving_helper/controllers/home_screen_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/header_repository.dart';
import 'package:saving_helper/repository/home_repository.dart';
import 'package:saving_helper/screen/account_information_screen.dart';
import 'package:saving_helper/screen/animated_Invite_banner.dart';
import 'package:saving_helper/screen/login_screen.dart';
import 'package:saving_helper/screen/member_screen.dart';
import 'package:saving_helper/screen/report_repay_screen.dart';
import 'package:saving_helper/screen/saving_plan_calculate_screen.dart';
import 'package:saving_helper/screen/shop/ProductFeedScreen.dart';
import 'package:saving_helper/screen/shop/product_management_screen.dart';
import 'package:saving_helper/screen/widgets/menu_grid/MenuGrid.dart';
import 'package:saving_helper/screen/widgets/menu_grid/MenuItem.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/share_storage.dart';

import '../splash_screen.dart';
import '../theme_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final HomeController controller = Get.put(HomeController(HomeRepository(ApiProvider())));
  // final ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    Get.delete<HomeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final HeaderController headerController = Get.put(HeaderController(HeaderRepository(ApiProvider())));
    final ShareStorage shareStorage = ShareStorage();

    return ThemedScaffold(
      child: Stack(
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              Column(
                children: [
                  CustomHeader(),
                  SizedBox(height: 15,),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard',  // Use null-aware operator to safely access userName
                          style: TextStyle(
                            color: ApplicationVariable.themeTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyBaseEnFont',
                          ),
                        ),
                        Row(
                          children: [
                            Text('Home /',
                              style: TextStyle(
                                color: ApplicationVariable.themeTextColor,
                                fontSize: 9,
                              ),),
                            Text(' Dashboard',
                              style: TextStyle(
                                color: ApplicationVariable.themeTextColor,
                                fontSize: 9,
                                fontFamily: 'MyBaseEnFont',
                              ),),
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 10,),
                        // New Component
                        _buildNewComponent(controller),
                        SizedBox(height: 20,),
                        // Saving Component
                        _buildSavingComponent(controller),
                        SizedBox(height: 20,),
                        // Loan Component
                        _buildLoanComponent(controller),
                        SizedBox(height: 20,),
                        // Balance Component
                        _buildBalanceComponent(controller),
                        SizedBox(height: 20,),
                        // AnimatedInviteBanner(),
                        MenuGrid(
                          menuItems: [
                            SavingPlanCalculateScreen(),
                            MenuItem(
                              icon: Icons.shopify,
                              label: 'ទិញទំនិញ',
                              onTap: () {
                                // Handle navigation to Home Screen
                                Get.to(() => ProductFeedScreen());
                              },
                              firstControlColor: ApplicationVariable.themeFirstGradientColor,
                              secondControlColor: ApplicationVariable.themeSecondGradientColor,
                              textColor: ApplicationVariable.themeTextColor,
                            ),
                            MenuItem(
                              icon: Icons.settings_outlined,
                              label: 'គ្រប់គ្រង',
                              isRotate: true,
                              onTap: () {
                                _showModalBottomSheet(context, headerController, shareStorage);
                              },
                              firstControlColor: ApplicationVariable.themeFirstGradientColor,
                              secondControlColor: ApplicationVariable.themeSecondGradientColor,
                              textColor: ApplicationVariable.themeTextColor,
                            ),
                            MenuItem(
                              icon: Icons.balance,
                              label: 'កម្ចី',
                              onTap: () {
                                Get.to(() => ReportRepayScreen());
                              },
                              firstControlColor: ApplicationVariable.themeFirstGradientColor,
                              secondControlColor: ApplicationVariable.themeSecondGradientColor,
                              textColor: ApplicationVariable.themeTextColor,
                            ),
                            MenuItem(
                              icon: Icons.supervised_user_circle_outlined,
                              label: 'ដៃគូសន្សំ',
                              isRotate: true,
                              onTap: () {
                                // Handle navigation to Home Screen
                                Get.to(() => MemberScreen());
                              },
                              firstControlColor: ApplicationVariable.themeFirstGradientColor,
                              secondControlColor: ApplicationVariable.themeSecondGradientColor,
                              textColor: ApplicationVariable.themeTextColor,
                            ),
                            MenuItem(
                              onTap: () {
                                // Handle navigation to Home Screen
                                Get.to(() => ProductManagementScreen());
                              },
                              icon: Icons.add_business,
                              label: 'គ្រប់គ្រងទំនិញ',
                              firstControlColor: ApplicationVariable.themeFirstGradientColor,
                              secondControlColor: ApplicationVariable.themeSecondGradientColor,
                              textColor: ApplicationVariable.themeTextColor,
                            )
                          ],
                        ),
                        SizedBox(height: 20,),
                        // AnimatedInviteBanner(),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
        ),
    );
  }
}

Widget _buildSavingComponent(HomeController controller) {
  return Column(
    children: [
      // Saving Component Start
      Center(
        child: GlassContainer(
          height: 95,
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
          blur: 20,
          borderRadius: BorderRadius.circular(24.0),
          borderWidth: 0.95,
          elevation: 4.0,
          shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      ApplicationVariable.themeFirstGradientColor.withOpacity(0.5),
                      ApplicationVariable.themeSecondGradientColor.withOpacity(0.3)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomCenter,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: themeController.theme.value?.textColor?.withOpacity(0.15) ?? Colors.black.withOpacity(0.15),
                  //     blurRadius: 6,
                  //     offset: Offset(0, 4),
                  //   ),
                  // ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Text('សន្សំ ',
                              style: TextStyle(
                                color: ApplicationVariable.themeTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyBaseFont',
                              ),),
                            Text('| សង្ខេប',
                              style: TextStyle(
                                color: ApplicationVariable.themeTextColor,
                                fontSize: 12,
                                fontFamily: 'MyBaseFont',
                              ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20,),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                final value = parseCurrency(controller.dashboard.value?.totalSavingDeposit);

                                return TweenAnimationBuilder<double>(
                                key: ValueKey(value),
                                tween: Tween(begin: 0.0, end: value),
                                duration: Duration(milliseconds: 800),
                                builder: (context, animatedValue, child) {
                                  return Text(
                                    formatCurrency(animatedValue),
                                    style: TextStyle(
                                      color: ApplicationVariable.themeTextColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: ApplicationVariable.themeShadowColor,
                                          blurRadius: 8,
                                        ),
                                      ],
                                      fontFamily: 'MyBaseEnFont',
                                    ),);
                                });
                              }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Obx(() {
                                      final value = parseCurrency(controller.dashboard.value?.savingToday);

                                      return TweenAnimationBuilder<double>(
                                          key: ValueKey(value),
                                          tween: Tween(begin: 0.0, end: value),
                                          duration: Duration(milliseconds: 800),
                                          builder: (context, animatedValue, child) {
                                            return Row(
                                              children: [
                                                Icon(Icons.trending_up, size: 14, color: Colors.greenAccent),
                                                const SizedBox(width: 4),
                                                Text(
                                                formatCurrency(animatedValue),
                                                  style: TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'MyBaseEnFont',
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.deepPurpleAccent,
                                                        blurRadius: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }),
                                    SizedBox(width: 8,),
                                    Text('ថ្ងៃនេះ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'MyBaseFont',
                                        shadows: [
                                          Shadow(
                                            color: Colors.deepPurpleAccent,
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Obx(() {
                                      final value = parseCurrency(controller.dashboard.value?.savingYesterday);

                                      return TweenAnimationBuilder<double>(
                                          key: ValueKey(value),
                                          tween: Tween(begin: 0.0, end: value),
                                          duration: Duration(milliseconds: 800),
                                          builder: (context, animatedValue, child) {
                                            return Row(
                                              children: [
                                                Icon(Icons.trending_up, size: 14, color: Colors.greenAccent),
                                                const SizedBox(width: 4),
                                                Text(
                                                  formatCurrency(animatedValue),
                                                  style: TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'MyBaseEnFont',
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.deepPurpleAccent,
                                                        blurRadius: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }),
                                    SizedBox(width: 8,),
                                    Text('ម្សិលមិញ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'MyBaseFont',
                                        shadows: [
                                          Shadow(
                                            color: Colors.deepPurpleAccent,
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Obx(() {
                                      final value = parseCurrency(controller.dashboard.value?.savingThisMonth);

                                      return TweenAnimationBuilder<double>(
                                          key: ValueKey(value),
                                          tween: Tween(begin: 0.0, end: value),
                                          duration: Duration(milliseconds: 800),
                                          builder: (context, animatedValue, child) {
                                            return Row(
                                              children: [
                                                Icon(Icons.trending_up, size: 14, color: Colors.greenAccent),
                                                const SizedBox(width: 4),
                                                Text(
                                                  formatCurrency(animatedValue),
                                                  style: TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'MyBaseEnFont',
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.deepPurpleAccent,
                                                        blurRadius: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }),
                                    SizedBox(width: 8,),
                                    Text('១ខែចុងក្រោយ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'MyBaseFont',
                                        shadows: [
                                          Shadow(
                                            color: Colors.deepPurpleAccent,
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // Saving Component End
    ],
  );
}

Widget _buildLoanComponent(HomeController controller) {
  return Column(
    children: [
      Center(
        child: InkWell(
          onTap: () {
            Get.to(() => ReportRepayScreen());
          },
          child: GlassContainer(
            height: 105,
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
            blur: 20,
            borderRadius: BorderRadius.circular(24.0),
            borderWidth: 0.95,
            elevation: 4.0,
            shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'កម្ចី',
                        style: TextStyle(
                          fontSize: 14,
                          color: ApplicationVariable.themeTextColor,
                          fontFamily: 'MyBaseFont',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '| ទាំងអស់',
                        style: TextStyle(
                          fontSize: 12,
                          color: ApplicationVariable.themeTextColor,
                          fontFamily: 'MyBaseFont',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Content Row
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ApplicationVariable.themeTextColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.currency_exchange_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(() {
                          final balance = parseCurrency(controller.dashboard.value?.loanBalance);

                          return TweenAnimationBuilder<double>(
                            key: ValueKey(balance),
                            tween: Tween(begin: 0, end: balance),
                            duration: const Duration(milliseconds: 800),
                            builder: (context, animatedValue, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatCurrency(animatedValue),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MyBaseEnFont',
                                      color: ApplicationVariable.themeTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.trending_up, size: 14, color: Colors.greenAccent,),
                                      const SizedBox(width: 4),
                                      Text(
                                        '25% increase',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'MyBaseEnFont',
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildBalanceComponent(HomeController controller) {
  return Column(
    children: [
      Center(
        child: GlassContainer(
          height: 105,
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
          blur: 20,
          borderRadius: BorderRadius.circular(24.0),
          borderWidth: 0.95,
          elevation: 4.0,
          shadowColor: ApplicationVariable.themeShadowColor.withOpacity(0.20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'សមតុល្យ',
                      style: TextStyle(
                        fontSize: 14,
                        color: ApplicationVariable.themeTextColor,
                        fontFamily: 'MyBaseFont',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '| ទាំងអស់',
                      style: TextStyle(
                        fontSize: 12,
                        color: ApplicationVariable.themeTextColor,
                        fontFamily: 'MyBaseFont',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Content Row
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ApplicationVariable.themeTextColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(() {
                        final balance = parseCurrency(controller.dashboard.value?.balance);

                        return TweenAnimationBuilder<double>(
                          key: ValueKey(balance),
                          tween: Tween(begin: 0, end: balance),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, animatedValue, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatCurrency(animatedValue),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'MyBaseEnFont',
                                    color: ApplicationVariable.themeTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.trending_up, size: 14, color: Colors.greenAccent),
                                    const SizedBox(width: 4),
                                    Text(
                                      '5% increase',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'MyBaseEnFont',
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}


Widget _buildNewComponent(HomeController controller) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    ApplicationVariable.themeFirstGradientColor.withOpacity(0.1),
                    ApplicationVariable.themeFirstGradientColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Obx(() {
                final target = double.tryParse(controller.dashboard.value?.target ?? '0.00') ?? 0.00;
                final progress = (target / 100).clamp(0.0, 1.0); // Ensure 0.0–1.0

                return TweenAnimationBuilder<double>(
                  key: ValueKey(target),
                  tween: Tween(begin: 0.0, end: progress),
                  duration: Duration(milliseconds: 800),
                  builder: (context, animatedValue, child) {
                    return CustomPaint(
                      painter: _GlassRingPainter(
                          animatedValue,
                          ApplicationVariable.themeFirstGradientColor,
                          ApplicationVariable.themeFirstGradientColor,
                      ),
                      child: Center(
                        child: Text(
                          '${(animatedValue * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: ApplicationVariable.themeTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyBaseEnFont',
                            shadows: [
                              Shadow(
                                color: Colors.deepPurpleAccent,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() {
                  final totalSavingDeposit = parseCurrency(controller.dashboard.value?.totalSavingDeposit);
                  return _buildMoneyBox(totalSavingDeposit, Colors.pinkAccent, Colors.orangeAccent, height: 40);
                }),
                SizedBox(height: 10),
                Obx(() {
                  final balance = parseCurrency(controller.dashboard.value?.balance);
                  return _buildMoneyBox(balance, Colors.lightBlueAccent, Colors.blue, height: 40);
                }),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

class _GlassRingPainter extends CustomPainter {
  final double progress;
  final Color? first;
  final Color? second;

  _GlassRingPainter(
      this.progress,
      this.first,
      this.second
      );

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.0;
    final radius = (size.width / 1.85) - strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);

    // Progress ring with semi-transparent gradient
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          first ?? Colors.orangeAccent,
          second ?? Colors.orangeAccent.withOpacity(0.9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Reflection highlight (simulate glass light refraction)
    final reflectionPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          first ?? Colors.white.withOpacity(0.9),
          Colors.transparent,
          second ?? Colors.white.withOpacity(0.9),
        ],
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromCircle(center: center, radius: radius + strokeWidth))
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw progress arc
    final angle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      progressPaint,
    );
    // Add outer reflection for glass effect
    canvas.drawCircle(center, radius + strokeWidth / 2, reflectionPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

double parseCurrency(String? input) {
  if (input == null) return 0.0;
  return double.tryParse(input.replaceAll(',', '')) ?? 0.0;
}

String formatCurrency(double value, {String symbol = '\$ ', int decimalDigits = 2, String locale = 'en_US'}) {
  return NumberFormat.currency(
    symbol: symbol,
    decimalDigits: decimalDigits,
    locale: locale,
  ).format(value);
}

Widget _buildMoneyBox(double value, Color color1, Color color2, {double height = 40}) {
  return TweenAnimationBuilder<double>(
    key: ValueKey(value), // 👈 Ensures animation on value change
    tween: Tween(begin: 0.0, end: value),
    duration: Duration(seconds: 1),
    builder: (context, animatedValue, child) {
      return Container(
        height: height,
        width: 270,
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color1, color2],
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
        child: Text(
          formatCurrency(animatedValue),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'MyBaseEnFont',
          ),
        ),
      );
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
            gradient: LinearGradient(
              colors: [Colors.black, ApplicationVariable.themeSecondGradientColor.withOpacity(0.9),],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: ApplicationVariable.themeShadowColor.withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
            // color: app_colors.menu3Color,
          ),
          child: ListView(
            children: [
              SizedBox(height: 4),
              AnimatedInviteBanner(),

              SizedBox(height: 8),

              // Profile Section
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ApplicationVariable.themeFirstGradientColor,
                      ApplicationVariable.themeSecondGradientColor.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.off(AccountInformationScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ApplicationVariable.themeFirstGradientColor,
                              ApplicationVariable.themeSecondGradientColor.withOpacity(0.9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: ApplicationVariable.themeTextColor,
                            width: 5.0,         // Border width
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            getInitials(displayName), style: TextStyle(
                              color: ApplicationVariable.themeTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                          ),
                        ),
                      ),
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
                                    color: ApplicationVariable.themeTextColor,
                                    fontFamily: 'MyBaseFont',
                                  ),
                                ),
                                Text(
                                  user?.emailAddress ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ApplicationVariable.themeTextColor,
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
                                colors: [
                                  ApplicationVariable.themeFirstGradientColor,
                                  ApplicationVariable.themeSecondGradientColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return _switchGroup(context, controller);
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Icon(
                                Icons.autorenew,
                                color: ApplicationVariable.themeTextColor,
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
              Text("Navigation", style: TextStyle(fontSize: 14, color: ApplicationVariable.themeTextColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseEnFont')),
              SizedBox(height: 8),
              ListTile(
                leading: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        ApplicationVariable.themeFirstGradientColor,
                        ApplicationVariable.themeSecondGradientColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: Icon(
                    Icons.dashboard_outlined,
                    size: 24,
                  ),
                ),
                title: Text('Dashboard', style: TextStyle(color: ApplicationVariable.themeTextColor, fontWeight: FontWeight.bold, fontFamily: 'MyBaseEnFont')),
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
                leading: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        ApplicationVariable.themeFirstGradientColor,
                        ApplicationVariable.themeSecondGradientColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: Icon(
                    Icons.login_outlined,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: ApplicationVariable.themeTextColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MyBaseEnFont',
                  ),
                ),
                onTap: () {
                  shareStorage.removeUserCredential();
                  shareStorage.removeToken();
                  shareStorage.removeGroupId();
                  shareStorage.removeGroupName();
                  shareStorage.removeUser();
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
Widget _switchGroup(BuildContext context, HeaderController controller) {
  return Obx(() {
    final groups = controller.groups.value?.groups ?? [];
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.all(0),
      title: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ApplicationVariable.themeFirstGradientColor,
              ApplicationVariable.themeSecondGradientColor.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: ApplicationVariable.themeShadowColor.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          // color: app_colors.menu3Color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.groups,
                  color: ApplicationVariable.themeTextColor,
                  size: 26), // Add an icon for the notification
              SizedBox(width: 10), // Space between the icon and text
              Text(
                'សូមជ្រើសរើសក្រុម',
                style: TextStyle(
                  color: ApplicationVariable.themeTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyBaseFont',
                ),
              ),
            ],
          ),
        ),
      ),
      contentPadding: EdgeInsets.all(12),
      content: groups.isEmpty
          ? Text(
          'No groups available', style: TextStyle(fontFamily: 'MyBaseFont'))
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
                controller.switchGroup(group.groupId!, group.groupName!);
                Get.to(() => SplashScreen());
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      ApplicationVariable.themeFirstGradientColor,
                      ApplicationVariable.themeSecondGradientColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ApplicationVariable.themeShadowColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                  color: isSelected ? ApplicationVariable.themeTextColor.withOpacity(0.5) : ApplicationVariable.themeTextColor,
                  border: isSelected
                      ? Border.all(color: ApplicationVariable.themeTextColor, width: 2)
                      : Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: ApplicationVariable.themeTextColor,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        groupName,
                        style: TextStyle(
                          fontFamily: 'MyBaseFont',
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight
                              .normal,
                          color: ApplicationVariable.themeTextColor,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: ApplicationVariable.themeTextColor, size: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actionsPadding: EdgeInsets.all(12),
      actions: <Widget>[
        // Button to close the dialog
        SizedBox(
          height: 40,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ApplicationVariable.themeFirstGradientColor,
                  ApplicationVariable.themeSecondGradientColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: ApplicationVariable.themeShadowColor.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'បោះបង់',
                style: TextStyle(fontSize: 16,
                  color: ApplicationVariable.themeTextColor,
                  fontFamily: 'MyBaseFont',
                  fontWeight: FontWeight.bold,),
              ),
            ),
          ),
        ),
      ],
    );
  });
}

String getInitials(String? fullName) {
  if (fullName == null || fullName.trim().isEmpty) return '';
  final parts = fullName.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts[0][0].toUpperCase();
  }
  final first = parts.first[0];
  final last = parts.last[0];
  return (first + last).toUpperCase();
}