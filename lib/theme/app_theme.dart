import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF006D5B);
  static const Color secondary = Color(0xFFE6EFD8);
  static const Color accent = Color(0xFFF27D26);
  static const Color background = Color(0xFFF8F8F8);
  static const Color text = Color(0xFF1A1A1A);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF9E9E9E);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      useMaterial3: true,
    );
  }
}
