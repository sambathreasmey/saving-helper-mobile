import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:saving_helper/constants/application_variable.dart';

class CustomNumberPad extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onDone; // optional hook

  const CustomNumberPad({
    super.key,
    required this.controller,
    this.onDone,
  });

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
    HapticFeedback.selectionClick();
    setState(() {
      if (value == 'DEL') {
        if (currentValue.isNotEmpty) {
          currentValue = currentValue.substring(0, currentValue.length - 1);
        }
      } else if (value == '.' && currentValue.contains('.')) {
        return;
      } else {
        // avoid leading zeros like "00" (except "0." path)
        if (currentValue == '0' && value != '.') {
          currentValue = value;
        } else {
          currentValue += value;
        }
      }
      widget.controller.text = currentValue;
    });
  }

  void _clearAll() {
    HapticFeedback.lightImpact();
    setState(() {
      currentValue = '';
      widget.controller.text = '';
    });
  }

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = ApplicationVariable.themeFirstGradientColor;
    final Color textColor = ApplicationVariable.themeTextColor;

    final List<String> keys = [
      '1','2','3','4','5','6','7','8','9','.','0','DEL'
    ];

    // Keyboard + safe-area aware bottom padding
    final media = MediaQuery.of(context);
    final keyboard = media.viewInsets.bottom;       // when keyboard is up
    final safeBottom = media.padding.bottom;        // iOS home indicator
    final extraBottom = _isIOS ? (safeBottom > 0 ? safeBottom : 12.0) : 12.0;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboard), // lift above keyboard
      child: SafeArea( // keep above iOS home indicator
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            // ensures smaller screens can scroll instead of clipping
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
                    (currentValue.isEmpty ? '0' : currentValue),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
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
                    final key = keys[index];
                    final isDel = key == 'DEL';

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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _input(key),
                          onLongPress: isDel ? _clearAll : null, // long-press DEL to clear
                          child: Center(
                            child: Text(
                              key,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // === Done Button (always fully visible on iOS) ===
                Padding(
                  padding: EdgeInsets.only(bottom: extraBottom),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        widget.onDone?.call();
                        // Close any bottom sheet/dialog if present
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isIOS
                            ? buttonColor.withOpacity(0.95) // slightly more solid on iOS
                            : buttonColor,
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: _isIOS ? 0 : 2,
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
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