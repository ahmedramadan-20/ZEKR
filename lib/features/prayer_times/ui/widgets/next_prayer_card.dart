import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../data/models/prayer_times_model.dart';

class NextPrayerCard extends StatelessWidget {
  final NextPrayer nextPrayer;

  const NextPrayerCard({
    super.key,
    required this.nextPrayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.white,
                size: 24.w,
              ),
              SizedBox(width: 12.w),
              Text(
                'الصلاة القادمة',
                style: AppTextStyles.bodyOnGradient.copyWith(
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Prayer Name
          Text(
            nextPrayer.name,
            style: AppTextStyles.displayLarge.copyWith(
              color: Colors.white,
              fontFamily: 'Amiri',
              fontSize: 32.sp,
            ),
          ),

          SizedBox(height: 8.h),

          // Prayer Time
          Text(
            _formatTime(nextPrayer.time),
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          ),

          SizedBox(height: 16.h),

          // Time Remaining
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: Colors.white,
                  size: 16.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'متبقي ${nextPrayer.formattedTimeRemaining}',
                  style: AppTextStyles.bodyOnGradient.copyWith(
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final formatter = DateFormat('hh:mm a', 'ar');
    return formatter.format(time);
  }
}
