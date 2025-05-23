
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saving_helper/controllers/home_screen_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/home_repository.dart';
import 'package:saving_helper/screen/animated_Invite_banner.dart';
import 'package:saving_helper/screen/report_repay_screen.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/screen/header.dart';

import '../constants/app_color.dart' as app_colors;
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

    return ThemedScaffold(
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                ListView(
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
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
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
                    AnimatedInviteBanner(),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
              // ignore: deprecated_member_use
              color: app_colors.baseWhiteColor.withOpacity(0.06),
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
                      colors: [Colors.white.withOpacity(0.1), Colors.black.withOpacity(0.5)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('សន្សំ ',
                              style: TextStyle(
                                color: app_colors.baseWhiteColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyBaseFont',
                              ),),
                            Text('| សង្ខេប',
                              style: TextStyle(
                                color: Colors.white,
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
                  padding: const EdgeInsets.all(14.0),
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
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.deepPurpleAccent,
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
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                  const SizedBox(height: 16),
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
                      const SizedBox(width: 16),
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
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                const SizedBox(height: 16),
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
                    const SizedBox(width: 16),
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
          Container(
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
