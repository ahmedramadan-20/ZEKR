import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/core/helpers/extensions.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../data/models/surah_response.dart';

class SurahListItem extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahListItem({super.key, required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Surah Number Circle
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    surah.number.toArabicNumber,
                    style: AppTextStyles.ayahNumber.copyWith(fontSize: 18.sp),
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Surah Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.englishName,
                      style: AppTextStyles.surahNameEnglish,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${surah.englishNameTranslation} • ${surah.numberOfAyahs} آيات',
                      style: AppTextStyles.surahTranslation,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16.w),

              // Arabic Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    surah.name,
                    style: AppTextStyles.surahNameArabic.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: surah.revelationType == 'Meccan'
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      surah.revelationType == 'Meccan' ? 'مكية' : 'مدنية',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: surah.revelationType == 'Meccan'
                            ? AppColors.primary
                            : AppColors.secondaryDark,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
