import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Arabic Quran Text
  static TextStyle quranArabic = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 28.sp,
    height: 2.2,
    color: AppColors.arabicText,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  // Bismillah
  static TextStyle bismillah = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 32.sp,
    height: 1.8,
    color: AppColors.bismillah,
    fontWeight: FontWeight.bold,
  );

  // Surah Names
  static TextStyle surahNameArabic = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 24.sp,
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );

  static TextStyle surahNameEnglish = TextStyle(
    fontSize: 18.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle surahTranslation = TextStyle(
    fontSize: 14.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
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
    fontFamily: 'Amiri',
    fontSize: 16.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle juzInfo = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 14.sp,
    color: AppColors.juzBadge,
    fontWeight: FontWeight.bold,
  );

  // Body Text
  static TextStyle bodyMedium = TextStyle(
    fontSize: 16.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 14.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle caption = TextStyle(
    fontSize: 12.sp,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );
}
