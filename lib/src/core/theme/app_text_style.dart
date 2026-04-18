import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  final Color color;

  AppTextStyle._(this.color);

  /// LIGHT MODE TEXT COLORS
  static final light = AppTextStyle._(Colors.black);

  /// DARK MODE TEXT COLORS
  static final dark = AppTextStyle._(Colors.white);

  /// AUTO SELECT (Based on Theme Brightness)
  static AppTextStyle auto(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppTextStyle.dark
        : AppTextStyle.light;
  }

  /// 🔥 Master Custom TextStyle Builder
  TextStyle custom({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: overrideColor ?? color,
    );
  }

  // HEADLINES
  TextStyle headlineSmall({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  TextStyle headlineMedium({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  TextStyle headlineLarge({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  // TITLES
  TextStyle titleSmall({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  TextStyle titleMedium({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  TextStyle titleLarge({
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  // BODY
  TextStyle bodySmall({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  TextStyle bodyMedium({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  TextStyle bodyLarge({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  // LABELS
  TextStyle labelSmall({
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  TextStyle labelMedium({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );

  TextStyle labelLarge({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? overrideColor,
  }) =>
      custom(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overrideColor: overrideColor,
      );
}