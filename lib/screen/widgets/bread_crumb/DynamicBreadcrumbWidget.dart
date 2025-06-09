import 'package:flutter/material.dart';

class DynamicBreadcrumbWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String path;
  final Color textColor;
  final double fontSize;
  final String fontFamily;

  DynamicBreadcrumbWidget({
    required this.title,
    required this.subTitle,
    required this.path,
    this.textColor = Colors.white, // Default color is white
    this.fontSize = 16, // Default font size
    this.fontFamily = 'MyBaseFont', // Default font family
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
            ),
          ),
          // Breadcrumb Path
          Row(
            children: [
              Text(
                '$subTitle /',
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize * 0.65, // Smaller font for the breadcrumb separator
                  fontFamily: fontFamily,
                ),
              ),
              Text(
                path,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize * 0.65, // Smaller font for the breadcrumb path
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}