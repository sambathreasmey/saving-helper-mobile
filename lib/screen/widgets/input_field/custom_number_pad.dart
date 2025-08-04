import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:saving_helper/constants/application_variable.dart';

class CustomNumberPad extends StatefulWidget {
  final TextEditingController controller;

  const CustomNumberPad({super.key, required this.controller});

  @override
  State<CustomNumberPad> createState() => _CustomNumberPadState();
}

class _CustomNumberPadState extends State<CustomNumberPad> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.controller.text;
  }

  void _input(String value) {
    setState(() {
      if (value == 'DEL') {
        if (currentValue.isNotEmpty) {
          currentValue = currentValue.substring(0, currentValue.length - 1);
        }
      } else if (value == '.' && currentValue.contains('.')) {
        return;
      } else {
        currentValue += value;
      }
      widget.controller.text = currentValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = ApplicationVariable.themeFirstGradientColor;
    final Color textColor = ApplicationVariable.themeTextColor;

    List<String> keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'DEL'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // === Display Input Value ===
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentValue.isEmpty ? '0' : currentValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // === Glass Number Pad ===
          GridView.builder(
            shrinkWrap: true,
            itemCount: keys.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              String key = keys[index];
              return GlassContainer.clearGlass(
                borderRadius: BorderRadius.circular(12),
                blur: 15,
                gradient: LinearGradient(
                  colors: [
                    buttonColor.withOpacity(0.15),
                    buttonColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                child: TextButton(
                  onPressed: () => _input(key),
                  child: Text(
                    key,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // === Done Button ===
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Done",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
