import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/theme_controller.dart';

class BaseButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool fullWidth;
  final double height;
  final double weight;
  final double fontSize;
  final String fontFamily;

  const BaseButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.height = 0,
    this.fontSize = 16,
    this.weight = 0,
    this.fontFamily = 'MyBaseFont',
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: height, horizontal: weight),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeController.theme.value?.firstControlColor ?? Colors.black,
            themeController.theme.value?.secondControlColor ?? Colors.black,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.black,
            blurRadius: 3,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}