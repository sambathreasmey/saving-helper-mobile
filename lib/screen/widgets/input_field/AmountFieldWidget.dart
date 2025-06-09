import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/theme_controller.dart';

class AmountFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool required;
  final String label;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final TextInputFormatter inputFormatter;

  AmountFieldWidget({
    required this.controller,
    this.required = false,
    this.label = 'Amount',
    this.prefixIcon = Icons.savings_outlined,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    required this.inputFormatter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          // You can add any custom behavior for text change here
        },
        keyboardType: keyboardType,
        inputFormatters: [inputFormatter],
        decoration: InputDecoration(
          labelText: required ? '$label *' : '$label (optional)',
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height: 60,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [
                    themeController.theme.value?.firstControlColor ?? Colors.black,
                    themeController.theme.value?.secondControlColor ?? Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeController.theme.value?.secondControlColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(prefixIcon, color: themeController.theme.value?.textColor ?? Colors.white),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        style: const TextStyle(fontFamily: 'MyBaseEnFont', color: Colors.black87),
      ),
    );
  }
}