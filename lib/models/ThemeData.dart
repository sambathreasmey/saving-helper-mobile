import 'dart:ui';

class ThemeDataModel {
  String? themePath;
  Color? firstControlColor;
  Color? secondControlColor;
  Color? textColor;

  ThemeDataModel({
    required this.themePath,
    required this.firstControlColor,
    required this.secondControlColor,
    required this.textColor,
  });

  ThemeDataModel.fromJson(Map<String, dynamic> json) {
    themePath = json['themePath'];

    final firstColorValue = json['firstControlColor'];
    if (firstColorValue != null && firstColorValue is int) {
      firstControlColor = Color(firstColorValue);
    }

    final secondColorValue = json['secondControlColor'];
    if (secondColorValue != null && secondColorValue is int) {
      secondControlColor = Color(secondColorValue);
    }

    final textColorValue = json['textColor'];
    if (textColorValue != null && textColorValue is int) {
      textColor = Color(textColorValue);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'themePath': themePath,
      'firstControlColor': firstControlColor?.value,
      'secondControlColor': secondControlColor?.value,
      'textColor': textColor?.value,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ThemeDataModel &&
              runtimeType == other.runtimeType &&
              themePath == other.themePath &&
              firstControlColor?.value == other.firstControlColor?.value &&
              secondControlColor?.value == other.secondControlColor?.value &&
              textColor?.value == other.textColor?.value;

  @override
  int get hashCode =>
      themePath.hashCode ^
      (firstControlColor?.value ?? 0).hashCode ^
      (secondControlColor?.value ?? 0).hashCode ^
      (textColor?.value ?? 0).hashCode;
}
