import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/controllers/theme_controller.dart';

class SelectItemWidget extends StatelessWidget {
  final String title;
  final List<String> itemList; // List of currency or any items
  final RxString selectedCurrency; // The reactive selected item (currency)
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final IconData suffixIcon;

  SelectItemWidget({
    required this.title,
    required this.itemList,
    required this.selectedCurrency,
    this.labelText = 'Currency',
    this.hintText = 'Select a currency',
    this.prefixIcon = Icons.switch_left,
    this.suffixIcon = Icons.arrow_drop_down,
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
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => _buildSelectCategory(context, themeController),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Obx(() => IgnorePointer(
          child: TextField(
            controller: TextEditingController(
              text: selectedCurrency.value.isEmpty
                  ? ""
                  : selectedCurrency.value,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: 60,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
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
              suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            style: const TextStyle(fontFamily: 'MyBaseEnFont', color: Colors.black87),
          ),
        )),
      ),
    );
  }

  Widget _buildSelectCategory(BuildContext context, ThemeController themeController) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.1,
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeController.theme.value?.firstControlColor ?? Colors.black,
                  themeController.theme.value?.secondControlColor ?? Colors.black,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: themeController.theme.value?.textColor ?? Colors.white,
                  fontFamily: 'MyBaseFont',
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (_, index) {
                final item = itemList[index];
                return InkWell(
                  onTap: () {
                    selectedCurrency.value = item;
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Text(item,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
