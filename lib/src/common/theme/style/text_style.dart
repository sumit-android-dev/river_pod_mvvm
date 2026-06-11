import 'package:flutter/material.dart';
import 'package:river_pod_mvvm/src/common/theme/color/colors.dart';
import 'package:river_pod_mvvm/src/common/theme/font/fonts.dart';

class AppTextStyle {
  AppTextStyle._(); // Prevent instantiation

  static TextStyle onestLight({
    Color? textColor,
    double? textSize,
  }) {
    return TextStyle(
      fontSize: textSize ?? 14.0,
      fontFamily: Fonts.onestLight,
      color: textColor ?? AppColors.black,
    );
  }

  static TextStyle onestRegular({
    Color? textColor,
    double? textSize,
  }) {
    return TextStyle(
      fontSize: textSize ?? 14.0,
      fontFamily: Fonts.onestRegular,
      color: textColor ?? AppColors.black,
    );
  }

  static TextStyle onestMedium({
    Color? textColor,
    double? textSize,
  }) {
    return TextStyle(
      fontSize: textSize ?? 14.0,
      fontFamily: Fonts.onestMedium,
      color: textColor ?? AppColors.black,
    );
  }

  static TextStyle onestSemiBold({
    Color? textColor,
    double? textSize,
  }) {
    return TextStyle(
      fontSize: textSize ?? 14.0,
      fontFamily: Fonts.onestSemiBold,
      color: textColor ?? AppColors.black,
    );
  }

  static TextStyle onestBold({
    Color? textColor,
    double? textSize,
  }) {
    return TextStyle(
      fontSize: textSize ?? 14.0,
      fontFamily: Fonts.onestBold,
      color: textColor ?? AppColors.black,
    );
  }
}
