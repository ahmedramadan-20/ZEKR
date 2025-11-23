import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Light Theme - Calm, Spiritual Design
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary, // Soft green
      onPrimary: Colors.white,
      secondary: AppColors.secondary, // Warm gold
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary, // Dark blue-grey
      error: AppColors.error,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background, // #FAFAFA - very light gray
    cardColor: AppColors.cardBackground,
    dividerColor: AppColors.divider,
    shadowColor: Colors.black.withOpacity(0.08),
    fontFamily: 'Amiri',
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: AppColors.textPrimary,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    iconTheme: const IconThemeData(color: AppColors.primary),
  );

  // Dark Theme - Calm, Spiritual Design for Low Light
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary, // Brighter green
      onPrimary: Colors.white,
      secondary: AppColors.darkSecondary, // Light gold
      onSecondary: Color(0xFF1B365D), // Dark text on gold
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary, // Light gray
      error: AppColors.error,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor:
        AppColors.darkBackground, // #121212 - OLED friendly
    cardColor: AppColors.darkCardBackground,
    dividerColor: AppColors.darkDivider,
    shadowColor: Colors.black.withOpacity(0.4),
    fontFamily: 'Amiri',
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    ),
    iconTheme: const IconThemeData(color: AppColors.darkPrimary),
  );
}
