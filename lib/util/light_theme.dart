import 'package:flutter/material.dart';

import 'pallete.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: "NeueMachina",
  hintColor: AppColor.dark.withOpacity(0.5),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColor.dark,
    
  ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontFamily: "NeueMachina",
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColor.dark),
      bodyMedium: TextStyle(
          fontFamily: "NeueMachina",
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColor.dark),
      bodySmall: TextStyle(
          fontFamily: "NeueMachina",
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: AppColor.dark)),
  appBarTheme:  AppBarTheme(
      backgroundColor: AppColor.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColor.tertiary),
      titleTextStyle: TextStyle(color: AppColor.dark.withOpacity(0.8),)),
  colorScheme:  ColorScheme.light(
      errorContainer: AppColor.error,
      onError: AppColor.dark,
      surface: AppColor.valid,
      onPrimary: AppColor.white,
      background: AppColor.white,
      onBackground: AppColor.dark,
      primary: AppColor.white,
    onTertiary: const Color.fromARGB(255, 31, 27, 74).withOpacity(0.95),
      secondary: AppColor.accentLight,
      tertiary: AppColor.tertiary),
);
