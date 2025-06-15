import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool fullWidth;
  final double height;
  final double weight;
  final double fontSize;
  final List<Color> backgroundColors;
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
    this.backgroundColors = const [Colors.blue, Colors.green],
    this.fontFamily = 'MyBaseFont',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: height, horizontal: weight),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: backgroundColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColors.last.withOpacity(0.3),
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