import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../data/models/prayer_times_model.dart';

class PrayerTimeCard extends StatelessWidget {
  final PrayerTime prayer;
  final bool hasPassed;
  final bool isNext;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.hasPassed,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isNext ? AppColors.primary.withOpacity(0.1) : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: isNext
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Prayer Icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isNext
                  ? AppColors.primary
                  : hasPassed
                      ? AppColors.textSecondary.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              _getPrayerIcon(prayer.type),
              color: isNext
                  ? Colors.white
                  : hasPassed
                      ? AppColors.textSecondary
                      : AppColors.primary,
              size: 24.w,
            ),
          ),

          SizedBox(width: 16.w),

          // Prayer Name
          Expanded(
            child: Text(
              prayer.name,
              style: AppTextStyles.titleSmall.copyWith(
                fontFamily: 'Amiri',
                color: hasPassed && !isNext
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          // Prayer Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(prayer.time),
                style: AppTextStyles.titleMedium.copyWith(
                  color: isNext ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isNext)
                Text(
                  'القادمة',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontFamily: 'Amiri',
                  ),
                ),
            ],
          ),

          if (hasPassed && !isNext)
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(
                Icons.check_circle,
                color: AppColors.textSecondary,
                size: 20.w,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return Icons.wb_twilight;
      case PrayerType.sunrise:
        return Icons.wb_sunny;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerType.asr:
        return Icons.wb_cloudy;
      case PrayerType.maghrib:
        return Icons.nights_stay;
      case PrayerType.isha:
        return Icons.dark_mode;
    }
  }

  String _formatTime(DateTime time) {
    final formatter = DateFormat('hh:mm a', 'ar');
    return formatter.format(time);
  }
}
