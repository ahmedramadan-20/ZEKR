import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Modern Headers
  static TextStyle displayLarge = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static TextStyle displayMedium = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );
  
  static TextStyle titleLarge = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.3,
  );
  
  static TextStyle titleMedium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
  
  static TextStyle titleSmall = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
  
  // Arabic Quran Text
  static TextStyle quranArabic = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 28.sp,
    height: 2.2,
    color: AppColors.arabicText,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Bismillah
  static TextStyle bismillah = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 36.sp,
    height: 1.8,
    color: AppColors.bismillah,
    fontWeight: FontWeight.bold,
  );

  // Surah Names
  static TextStyle surahNameArabic = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 24.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static TextStyle surahNameEnglish = TextStyle(
    fontSize: 18.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static TextStyle surahTranslation = TextStyle(
    fontSize: 13.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // Ayah Number
  static TextStyle ayahNumber = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 18.sp,
    color: AppColors.ayahNumber,
    fontWeight: FontWeight.bold,
  );

  // Page & Juz Info
  static TextStyle pageInfo = TextStyle(
    fontSize: 14.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle juzInfo = TextStyle(
    fontSize: 12.sp,
    color: AppColors.juzBadge,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  // Body Text
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle caption = TextStyle(
    fontSize: 11.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  
  // Labels
  static TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  static TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  // On Gradient Text
  static TextStyle titleOnGradient = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnGradient,
    letterSpacing: 0.2,
  );
  
  static TextStyle bodyOnGradient = TextStyle(
    fontSize: 14.sp,
    color: AppColors.textOnGradient,
    fontWeight: FontWeight.w500,
  );
}
