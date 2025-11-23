import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../data/models/search_result_model.dart';
import 'highlighted_ayah_text.dart';

class AyahSearchResultItem extends StatelessWidget {
  final SearchResult result;
  final String? query;
  final VoidCallback onTap;

  const AyahSearchResultItem({
    super.key,
    required this.result,
    this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ayah = result.ayah!;
    final surah = result.surah;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Surah name and Ayah number
                Row(
                  children: [
                    // Ayah number badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'آية ${ayah.numberInSurah}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Surah name
                    Expanded(
                      child: Text(
                        surah.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                    // English name
                    Text(
                      surah.englishName,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Ayah text (truncated) with highlighting
                HighlightedAyahText(
                  text: ayah.text,
                  query: query ?? '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
