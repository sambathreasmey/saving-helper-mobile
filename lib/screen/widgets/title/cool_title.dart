import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/theme_controller.dart';

class CoolTitle extends StatelessWidget {
  final String title;
  const CoolTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final firstColor = themeController.theme.value?.firstControlColor ?? Colors.pinkAccent;
        final secondColor = themeController.theme.value?.secondControlColor ?? Colors.deepPurpleAccent;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [firstColor, secondColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              blendMode: BlendMode.srcIn,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyBaseFont',
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25),
                    ),
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
