import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';

class AppThemeHelper {
  final MaterialColor primaryColor;

  AppThemeHelper({required this.primaryColor});

  ThemeData get lightTheme => appLightTheme();
  ThemeData get darkTheme => appDarkTheme();

  ThemeData appLightTheme() {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColor.backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.cardSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.blackColor),
        titleTextStyle: TextStyle(
          color: AppColor.blackColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColor.cardSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  ThemeData appDarkTheme() {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: primaryColor,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColor.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColor.darkTextPrimary),
        titleTextStyle: const TextStyle(
          color: AppColor.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColor.darkCardSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
