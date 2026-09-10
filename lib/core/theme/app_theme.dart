import 'package:flutter/material.dart';

class AppColors {
  static const Color oceanBlue = Color(0xFF0A2472);
  static const Color skyBlue = Color(0xFF0E6BA8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7FA);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.oceanBlue,
        primary: AppColors.oceanBlue,
        secondary: AppColors.skyBlue,
      ),
      fontFamily: 'Roboto',
    );
  }
}
