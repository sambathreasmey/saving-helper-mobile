
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import 'package:saving_helper/screen/widgets/menu_grid/MenuGrid.dart';
import 'package:saving_helper/screen/widgets/menu_grid/MenuItem.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/services/share_storage.dart';

import '../constants/app_color.dart' as app_colors;
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
  final ThemeController themeController = Get.put(ThemeController());

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
                            color: themeController.theme.value?.textColor ?? Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyBaseEnFont',
                          ),
                        ),
                        Row(
                          children: [
                            Text('Home /',
                              style: TextStyle(
                                color: themeController.theme.value?.textColor ?? Colors.white,
                                fontSize: 9,
                              ),),
                            Text(' Dashboard',
                              style: TextStyle(
                                color: themeController.theme.value?.textColor ?? Colors.white,
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
                        _buildNewComponent(controller, themeController),
                        SizedBox(height: 20,),
                        // Saving Component
                        _buildSavingComponent(controller, themeController),
                        SizedBox(height: 20,),
                        // Loan Component
                        _buildLoanComponent(controller, themeController),
                        SizedBox(height: 20,),
                        // Balance Component
                        _buildBalanceComponent(controller, themeController),
                        SizedBox(height: 20,),
                        // AnimatedInviteBanner(),
                        MenuGrid(
                          menuItems: [
                            SavingPlanCalculateScreen(),
                            MenuItem(
                              icon: Icons.supervised_user_circle_outlined,
                              label: 'ដៃគូសន្សំ',
                              onTap: () {
                                // Handle navigation to Home Screen
                                Get.to(() => MemberScreen());
                              },
                              firstControlColor: themeController.theme.value?.firstControlColor,
                              secondControlColor: themeController.theme.value?.secondControlColor,
                              textColor: themeController.theme.value?.textColor,
                            ),
                            MenuItem(
                              icon: Icons.settings_outlined,
                              label: 'គ្រប់គ្រង',
                              onTap: () {
                                _showModalBottomSheet(context, headerController, shareStorage, themeController);
                              },
                              firstControlColor: themeController.theme.value?.firstControlColor,
                              secondControlColor: themeController.theme.value?.secondControlColor,
                              textColor: themeController.theme.value?.textColor,
                            ),
                            MenuItem(
                              icon: Icons.balance,
                              label: 'កម្ចី',
                              onTap: () {
                                Get.to(() => ReportRepayScreen());
                              },
                              firstControlColor: themeController.theme.value?.firstControlColor,
                              secondControlColor: themeController.theme.value?.secondControlColor,
                              textColor: themeController.theme.value?.textColor,
                            ),
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

Widget _buildSavingComponent(HomeController controller, ThemeController themeController) {
  return Column(
    children: [
      // Saving Component Start
      Center(
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.3),
              //   ),
              // ],
              borderRadius: BorderRadius.circular(20),
              // ignore: deprecated_member_use
              color: themeController.theme.value?.textColor?.withOpacity(0.02),
              border: Border.all(
                color: themeController.theme.value?.textColor?.withOpacity(0.9) ?? Colors.white,
              ),
            ),
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
                        themeController.theme.value?.textColor?.withOpacity(0.08) ?? Colors.white.withOpacity(0.08),
                        themeController.theme.value?.textColor?.withOpacity(0.04) ?? Colors.black.withOpacity(0.04)
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
                        Row(
                          children: [
                            Text('សន្សំ ',
                              style: TextStyle(
                                color: themeController.theme.value?.textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyBaseFont',
                              ),),
                            Text('| សង្ខេប',
                              style: TextStyle(
                                color: themeController.theme.value?.textColor,
                                fontSize: 12,
                                fontFamily: 'MyBaseFont',
                              ),),
                          ],
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
                                        color: themeController.theme.value?.textColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.deepPurpleAccent,
                                            blurRadius: 8,
                                          ),
                                        ],
                                        fontFamily: 'MyBaseEnFont',
                                      ),);
                                  });
                                }),
                              ],
                            ),
                            Column(
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
      ),
      // Saving Component End
    ],
  );
}

Widget _buildLoanComponent(HomeController controller, ThemeController themeController) {
  return Column(
    children: [
      Center(
        child: InkWell(
          onTap: () {
            Get.to(() => ReportRepayScreen());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  themeController.theme.value?.firstControlColor ?? Colors.black,
                  themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeController.theme.value?.secondControlColor?.withOpacity(0.25) ?? Colors.blueAccent.withOpacity(0.25),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
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
                          color: themeController.theme.value?.textColor ?? Colors.white,
                          fontFamily: 'MyBaseFont',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '| ទាំងអស់',
                        style: TextStyle(
                          fontSize: 12,
                          color: themeController.theme.value?.textColor ?? Colors.white,
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
                          color: themeController.theme.value?.textColor?.withOpacity(0.15) ?? Colors.white.withOpacity(0.15),
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
                                      color: themeController.theme.value?.textColor ?? Colors.white,
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

Widget _buildBalanceComponent(HomeController controller, ThemeController themeController) {
  return Column(
    children: [
      Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                themeController.theme.value?.firstControlColor ?? Colors.black,
                themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: themeController.theme.value?.secondControlColor?.withOpacity(0.25) ?? Colors.blueAccent.withOpacity(0.25),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
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
                        color: themeController.theme.value?.textColor ?? Colors.white,
                        fontFamily: 'MyBaseFont',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '| ទាំងអស់',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeController.theme.value?.textColor ?? Colors.white,
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
                        color: themeController.theme.value?.textColor?.withOpacity(0.15) ?? Colors.white.withOpacity(0.15),
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
                                    color: themeController.theme.value?.textColor ?? Colors.white,
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


Widget _buildNewComponent(HomeController controller, ThemeController themeController) {
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
                    themeController.theme.value?.firstControlColor ?? Colors.black,
                    themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
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
                      painter: _RingPainter(animatedValue),
                      child: Center(
                        child: Text(
                          '${(animatedValue * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: themeController.theme.value?.textColor ?? Colors.white,
                            fontSize: 14,
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

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter(this.progress);

  @override
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final shadowStrokeWidth = strokeWidth + 6; // slightly larger for shadow
    final radius = (size.width / 1.7) - strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final backgroundPaint = Paint()
      ..color = Colors.grey[850]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final shadowPaint = Paint()
      ..color = Colors.orangeAccent.withOpacity(0.5) // shadow color
      ..strokeWidth = shadowStrokeWidth
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6); // blur radius

    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pinkAccent, Colors.orangeAccent],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Background ring
    canvas.drawCircle(center, radius, backgroundPaint);

    // Shadow behind the progress arc
    final angle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      shadowPaint,
    );

    // Foreground gradient arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      progressPaint,
    );
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

void _showModalBottomSheet(BuildContext context, HeaderController controller, ShareStorage shareStorage, ThemeController themeController) {
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
              colors: [Colors.black, themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.blueAccent.withOpacity(0.3),
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
                      themeController.theme.value?.firstControlColor ?? Colors.black,
                      themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
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
                              themeController.theme.value?.firstControlColor ?? Colors.black,
                              themeController.theme.value?.secondControlColor?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: themeController.theme.value?.textColor ?? Colors.white, // Border color
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
                            getInitials(displayName), style: TextStyle(color: themeController.theme.value!.textColor ?? Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
                                    color: themeController.theme.value?.textColor ?? Colors.white,
                                    fontFamily: 'MyBaseFont',
                                  ),
                                ),
                                Text(
                                  user?.emailAddress ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.theme.value?.textColor ?? Colors.white,
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
                                  themeController.theme.value?.firstControlColor ?? Colors.black,
                                  themeController.theme.value?.secondControlColor ?? Colors.black,
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
                                    return _switchGroup(context, controller, themeController);
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Icon(
                                Icons.autorenew,
                                color: themeController.theme.value?.textColor ?? Colors.white,
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
              Text("Navigation", style: TextStyle(fontSize: 14, color: themeController.theme.value?.textColor ?? Colors.white, fontWeight: FontWeight.bold, fontFamily: 'MyBaseEnFont')),
              SizedBox(height: 8),
              ListTile(
                leading: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        themeController.theme.value?.firstControlColor ?? Colors.black,
                        themeController.theme.value?.secondControlColor ?? Colors.black,
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
                title: Text('Dashboard', style: TextStyle(color:themeController.theme.value?.textColor ?? Colors.white, fontWeight: FontWeight.bold, fontFamily: 'MyBaseEnFont')),
                onTap: () {
                  Get.delete<HeaderController>();
                  Get.to(() => HomeScreen());
                },
              ),

              ManagementSubMenu(themeController: themeController,),
              ReportSubMenu(themeController: themeController,),

              // Logout
              SizedBox(height: 24),
              Divider(thickness: 1),
              ListTile(
                leading: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        themeController.theme.value?.firstControlColor ?? Colors.black,
                        themeController.theme.value?.secondControlColor ?? Colors.black,
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
                    color: themeController.theme.value?.textColor ?? Colors.white,
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
Widget _switchGroup(BuildContext context, HeaderController controller, ThemeController themeController) {
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
              themeController.theme.value?.firstControlColor ?? Colors.black,
              themeController.theme.value?.secondControlColor?.withOpacity(
                  0.9) ?? Colors.black.withOpacity(0.9),
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
              color: themeController.theme.value?.secondControlColor
                  ?.withOpacity(0.3) ?? Colors.black.withOpacity(0.9),
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
                  color: themeController.theme.value?.textColor ?? Colors.white,
                  size: 26), // Add an icon for the notification
              SizedBox(width: 10), // Space between the icon and text
              Text(
                'សូមជ្រើសរើសក្រុម',
                style: TextStyle(
                  color: themeController.theme.value?.textColor ?? Colors.white,
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
                      themeController.theme.value?.firstControlColor ??
                          Colors.black,
                      themeController.theme.value?.secondControlColor ??
                          Colors.black,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeController.theme.value?.secondControlColor
                          ?.withOpacity(0.3) ?? Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                  color: isSelected ? themeController.theme.value?.textColor
                      ?.withOpacity(0.5) ?? Colors.white : themeController.theme
                      .value?.textColor ?? Colors.white,
                  border: isSelected
                      ? Border.all(color: themeController.theme.value
                      ?.textColor ?? Colors.white, width: 2)
                      : Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: themeController.theme.value?.textColor ??
                          Colors.white,
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
                          color: themeController.theme.value?.textColor ??
                              Colors.white,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: themeController.theme
                          .value?.textColor ?? Colors.white, size: 20),
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
                  themeController.theme.value?.firstControlColor ??
                      Colors.black,
                  themeController.theme.value?.secondControlColor ??
                      Colors.black,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: themeController.theme.value?.secondControlColor
                      ?.withOpacity(0.1) ?? Colors.black.withOpacity(0.1),
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
                  color: themeController.theme.value?.textColor ?? Colors.white,
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