import 'dart:math';
import 'package:flutter/material.dart';

class CircleProgressComponent extends StatelessWidget {
  final double totalGoal;
  final double currentProgress;
  final double size;
  final List<Color> progressColors;  // Gradient colors for the progress ring
  final Color backgroundColor;       // Background color for the progress ring
  final double strokeWidth;          // Stroke width for the ring
  final Color progressTitleColor;

  const CircleProgressComponent({
    super.key,
    required this.totalGoal,
    required this.currentProgress,
    this.size = 60.0, // Default size of the progress ring
    this.progressColors = const [Colors.blue, Colors.green], // Default gradient colors
    this.backgroundColor = Colors.grey, // Default background color
    this.strokeWidth = 8.0, // Default stroke width
    this.progressTitleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage = (currentProgress / totalGoal * 100).clamp(0.0, 100.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: AnimatedProgressRing(
        progress: progressPercentage,
        size: size,
        progressColors: progressColors,
        backgroundColor: backgroundColor,
        strokeWidth: strokeWidth,
        progressTitleColor: progressTitleColor,
      ),
    );
  }
}

class AnimatedProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final List<Color> progressColors;
  final Color backgroundColor;
  final double strokeWidth;
  final Color progressTitleColor;

  const AnimatedProgressRing({super.key,
    required this.progress,
    required this.size,
    required this.progressColors,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.progressTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress / 100),
      duration: Duration(milliseconds: 800),
      builder: (context, animatedValue, child) {
        return CustomPaint(
          size: Size(size, size), // Ensure to give the size
          painter: _RingPainter(animatedValue, progress, progressColors, backgroundColor, strokeWidth, progressTitleColor),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double percentage;
  final List<Color> progressColors;
  final Color backgroundColor;
  final double strokeWidth;
  final Color progressTitleColor;

  _RingPainter(this.progress, this.percentage, this.progressColors, this.backgroundColor, this.strokeWidth, this.progressTitleColor);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width / 2) - strokeWidth;

    final paint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: progressColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final textPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    // Draw background ring
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    // Draw progress ring
    final angle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
      -pi / 2,
      angle,
      false,
      progressPaint,
    );

    // Draw percentage text in the center
    final percentageText = '${(percentage).toStringAsFixed(0)}%';
    final textStyle = TextStyle(
      color: progressTitleColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: percentageText, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width);

    final offset = Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}