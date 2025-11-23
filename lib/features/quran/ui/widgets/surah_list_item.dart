import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/core/helpers/extensions.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../data/models/surah_response.dart';

class SurahListItem extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;
  final bool isLastRead;

  const SurahListItem({
    super.key,
    required this.surah,
    required this.onTap,
    this.isLastRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMeccan = surah.revelationType == 'Meccan';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: isLastRead
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Surah Number with Gradient
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: isLastRead ? AppColors.cardGradient : null,
                  color: isLastRead
                      ? null
                      : (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSurface
                            : AppColors.backgroundGradient1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    surah.number.toArabicNumber,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isLastRead ? Theme.of(context).colorScheme.onPrimary : AppColors.primary,
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
                      surah.englishName,
                      style: AppTextStyles.surahNameEnglish.copyWith(
                        fontSize: 16.sp,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            surah.englishNameTranslation,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isMeccan
                                ? AppColors.makkiBadge.withOpacity(0.1)
                                : AppColors.madaniBadge.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            isMeccan ? 'مكية' : 'مدنية',
                            style: AppTextStyles.caption.copyWith(
                              color: isMeccan
                                  ? AppColors.makkiBadge
                                  : AppColors.madaniBadge,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arabic Name & Ayah Count
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    surah.name,
                    style: AppTextStyles.surahNameArabic.copyWith(
                      fontSize: 18.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.iconSecondary,
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${surah.numberOfAyahs} آية',
                        style: AppTextStyles.caption.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
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
