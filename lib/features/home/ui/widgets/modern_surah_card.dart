import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class ModernSurahCard extends StatelessWidget {
  final int surahNumber;
  final String arabicName;
  final String englishName;
  final String revelation;
  final int ayahCount;
  final VoidCallback onTap;
  final bool isLastRead;
  
  const ModernSurahCard({
    super.key,
    required this.surahNumber,
    required this.arabicName,
    required this.englishName,
    required this.revelation,
    required this.ayahCount,
    required this.onTap,
    this.isLastRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: isLastRead
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Surah Number Circle
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: isLastRead
                      ? AppColors.cardGradient
                      : null,
                  color: isLastRead ? null : AppColors.backgroundGradient1,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    surahNumber.toString(),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isLastRead ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
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
                      arabicName,
                      style: AppTextStyles.surahNameArabic.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          englishName,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: revelation == 'Meccan'
                                ? AppColors.makkiBadge.withOpacity(0.1)
                                : AppColors.madaniBadge.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            revelation == 'Meccan' ? 'مكية' : 'مدنية',
                            style: AppTextStyles.caption.copyWith(
                              color: revelation == 'Meccan'
                                  ? AppColors.makkiBadge
                                  : AppColors.madaniBadge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Ayah Count
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.iconSecondary,
                    size: 20.w,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$ayahCount آية',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
