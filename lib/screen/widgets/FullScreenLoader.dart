import 'dart:ui';
import 'package:flutter/material.dart';

class FullScreenLoader extends StatefulWidget {
  final bool isLoading;
  final String? loadingText;
  final List<Color>? glowColors;

  const FullScreenLoader({
    super.key,
    required this.isLoading,
    this.loadingText,
    this.glowColors,
  });

  @override
  State<FullScreenLoader> createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<FullScreenLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return const SizedBox.shrink();

    final glowColors = widget.glowColors ??
        [Colors.blueAccent, Colors.purpleAccent];

    return Positioned.fill(
      child: Stack(
        children: [
          // Background blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Center loader
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing ring animation
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: glowColors[0]
                                .withOpacity(0.5 * _controller.value),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                        gradient: SweepGradient(
                          colors: glowColors,
                          startAngle: 0,
                          endAngle: 6.28,
                          transform: GradientRotation(
                            _controller.value * 6.28,
                          ),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.savings_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Animated Loading Text
                _AnimatedDotsText(
                  text: widget.loadingText ?? "កំពុងដំណើរការ",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 👇 Animated dots in "Loading..."
class _AnimatedDotsText extends StatefulWidget {
  final String text;

  const _AnimatedDotsText({super.key, required this.text});

  @override
  State<_AnimatedDotsText> createState() => _AnimatedDotsTextState();
}

class _AnimatedDotsTextState extends State<_AnimatedDotsText>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotController,
      builder: (_, __) {
        int dotCount = ((_dotController.value * 3) % 3).floor() + 1;
        String dots = "." * dotCount;

        return Text(
          "${widget.text}$dots",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        );
      },
    );
  }
}
