import 'package:flutter/material.dart';

class LineProgressComponent extends StatelessWidget {
  final double totalGoal;
  final double currentProgress;
  final double height;
  final double width;
  final List<Color> progressColors;  // List of colors for gradient
  final Color backgroundColor; // Color for the background progress line
  final double strokeWidth;  // Dynamic stroke width for the line
  final Color progressTitleColor;

  const LineProgressComponent({
    super.key,
    required this.totalGoal,
    required this.currentProgress,
    this.height = 16.0, // Height of the progress line
    this.width = 100.0, // Height of the progress line
    this.progressColors = const [Colors.blue, Colors.green], // Default gradient colors
    this.backgroundColor = Colors.grey, // Default background color
    this.strokeWidth = 6.0,
    this.progressTitleColor = Colors.black, // Default stroke width
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage = (currentProgress / totalGoal * 100).clamp(0.0, 100.0);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.1),
      ),
      child: AnimatedProgressLine(
        progress: progressPercentage,
        height: height,
        gradientColors: progressColors,
        backgroundColor: backgroundColor,
        strokeWidth: strokeWidth,
        progressTitleColor: progressTitleColor,
      ),
    );
  }
}

class AnimatedProgressLine extends StatelessWidget {
  final double progress;
  final double height;
  final List<Color> gradientColors;  // List of gradient colors
  final Color backgroundColor;
  final double strokeWidth;
  final Color progressTitleColor;

  const AnimatedProgressLine({super.key,
    required this.progress,
    required this.height,
    required this.gradientColors,
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
          size: Size(double.infinity, height), // Ensure to give the size
          painter: _LinePainter(animatedValue, gradientColors, backgroundColor, strokeWidth, progressTitleColor),
        );
      },
    );
  }
}

class _LinePainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;  // List of gradient colors
  final Color backgroundColor;
  final double strokeWidth;
  final Color progressTitleColor;

  _LinePainter(this.progress, this.gradientColors, this.backgroundColor, this.strokeWidth, this.progressTitleColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,  // Use the list of gradient colors
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw background line
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    // Draw progress line
    final progressWidth = size.width * progress;
    canvas.drawLine(Offset(0, size.height / 2), Offset(progressWidth, size.height / 2), progressPaint);

    // Draw percentage text in the center of the line
    final percentageText = '${(progress * 100).toStringAsFixed(0)}%';
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