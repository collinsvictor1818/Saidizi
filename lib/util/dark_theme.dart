import 'package:flutter/material.dart';
import 'pallete.dart';

ThemeData darkTheme = ThemeData(
    fontFamily: "NeueMachina",
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
            fontFamily: "NeueMachina",
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColor.white),
        bodyMedium: TextStyle(
            fontFamily: "NeueMachina",
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColor.white),
        bodySmall: TextStyle(
            fontFamily: "NeueMachina",
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: AppColor.white)),
    brightness: Brightness.dark,
    hintColor: AppColor.white.withOpacity(0.3),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.dark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.tertiary),
      titleTextStyle: TextStyle(color: AppColor.tertiary),
    ),
    colorScheme: const ColorScheme.dark(
        errorContainer: AppColor.error,
        surface: AppColor.valid,
        onError: AppColor.dark,
        background: AppColor.dark,
        onBackground: AppColor.white,
        onTertiary: AppColor.tertiary,
        primary: AppColor.dark,
        secondary: AppColor.accentDark,
        tertiary: AppColor.tertiary),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColor.tertiary,
    ));
