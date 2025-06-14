import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/deposit_saving_controller.dart';
import 'package:saving_helper/controllers/theme_controller.dart';
import 'package:saving_helper/repository/deposit_saving_repository.dart';
import 'package:saving_helper/screen/widgets/bread_crumb/DynamicBreadcrumbWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/AmountFieldWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/DatePickerWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/SelectItemWidget.dart';
import 'package:saving_helper/screen/widgets/input_field/TextFieldWidget.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/screen/header.dart';
import 'package:saving_helper/theme_screen.dart';

class GoalManagementScreen extends StatefulWidget {
  const GoalManagementScreen({super.key});

  @override
  _GoalManagementScreenState createState() => _GoalManagementScreenState();
}

class _GoalManagementScreenState extends State<GoalManagementScreen> {
  final DepositSavingController controller =
  Get.put(DepositSavingController(DepositSavingRepository(ApiProvider())));
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CustomHeader(),
                    const SizedBox(height: 16),
                    DynamicBreadcrumbWidget(
                      title: 'គ្រប់គ្រង',
                      subTitle: 'គ្រប់គ្រង',
                      path: 'គម្រោងសន្សំប្រាក់',
                      textColor: themeController.theme.value?.textColor ?? Colors.white,
                    ),
                    const SizedBox(height: 16),
                    totalGroupComponent(context),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TextFieldWidget(
                          controller: controller.transactionDescController,
                          required: true,
                          label: 'ឈ្មោះគម្រោង',
                          prefixIcon: Icons.grass_outlined,
                          keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      AmountFieldWidget(
                        controller: controller.amountController,
                        required: true,
                        prefixIcon: Icons.monetization_on_outlined,
                        label: 'ទំហំសាច់ប្រាក់',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget totalGroupComponent(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust blur level
        child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withOpacity(0.2),
              ),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          themeController.theme.value?.secondControlColor ?? Colors.black,
                          themeController.theme.value?.firstControlColor ?? Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Obx(() {
                      final target = double.tryParse(controller.amount.value ?? '0.00') ?? 86.00;
                      final progress = (target / 100).clamp(0.0, 1.0); // Ensure 0.0–1.0
      
                      return TweenAnimationBuilder<double>(
                        key: ValueKey(target),
                        tween: Tween(begin: 0.0, end: progress),
                        duration: Duration(milliseconds: 800),
                        builder: (context, animatedValue, child) {
                          return CustomPaint(
                            painter: _RingPainter(animatedValue, themeController),
                            child: Center(
                              child: Text(
                                '${(animatedValue * 100).toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: themeController.theme.value?.textColor ?? Colors.white,
                                  fontSize: 20,
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
            ),
        ),
      ),
    );
  }


}

class _RingPainter extends CustomPainter {
  final double progress;
  final ThemeController themeController;

  _RingPainter(this.progress,
      this.themeController);

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
        colors: [
          themeController.theme.value?.secondControlColor ?? Colors.black,
          themeController.theme.value?.firstControlColor ?? Colors.black.withOpacity(0.9),
        ],
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