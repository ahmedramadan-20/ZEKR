import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class SurahHeader extends StatelessWidget {
  final String surahName;
  final String surahNameEnglish;
  final String revelationType;
  final int numberOfAyahs;

  const SurahHeader({
    super.key,
    required this.surahName,
    required this.surahNameEnglish,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Arabic Name
          Text(
            surahName,
            style: AppTextStyles.surahNameArabic.copyWith(
              color: Colors.white,
              fontSize: 32.sp,
            ),
          ),

          SizedBox(height: 8.h),

          // English Name
          Text(
            surahNameEnglish,
            style: AppTextStyles.surahNameEnglish.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 20.sp,
            ),
          ),

          SizedBox(height: 16.h),

          // Divider
          Container(
            height: 1,
            width: 100.w,
            color: Colors.white.withOpacity(0.3),
          ),

          SizedBox(height: 16.h),

          // Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoItem(
                revelationType == 'Meccan' ? 'مكية' : 'مدنية',
                Icons.location_on_outlined,
              ),
              SizedBox(width: 24.w),
              _buildInfoItem(
                '${numberOfAyahs.toArabicNumber} آية',
                Icons.menu_book_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 18.w),
        SizedBox(width: 6.w),
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
