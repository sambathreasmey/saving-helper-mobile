import 'package:flutter/material.dart';

class MenuItem extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color? firstControlColor;
  final Color? secondControlColor;
  final Color? textColor;

  const MenuItem({
    required this.onTap,
    required this.icon,
    required this.label,
    this.firstControlColor,
    this.secondControlColor,
    this.textColor,
    super.key,
  });

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with infinite rotation
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration of one full rotation
      vsync: this,
    );

    // Rotation animation from 0 to 2π (360 degrees)
    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Start the rotation animation loop
    _controller.repeat(); // Continuous loop for rotation
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap, // Trigger onTap callback
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.firstControlColor ?? Colors.black,
                    widget.secondControlColor ?? Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(21),
                boxShadow: [
                  BoxShadow(
                    color: widget.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                      angle: _iconRotationAnimation.value,
                    child: Center(
                      child: Icon(
                        widget.icon,
                        size: 35,
                        color: widget.textColor ?? Colors.white,
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'MyBaseFont',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: widget.textColor ?? Colors.white,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when not in use
    super.dispose();
  }
}
