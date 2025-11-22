import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../prayer_times/logic/cubit/prayer_times_cubit.dart';
import '../../../prayer_times/logic/cubit/prayer_times_state.dart';
import '../../../prayer_times/data/models/prayer_times_model.dart';

class PrayerTimesHorizontal extends StatelessWidget {
  const PrayerTimesHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoadingState(),
          loading: () => _buildLoadingState(),
          success: (prayerTimes) => _buildSuccessState(context, prayerTimes),
          error: (message) => _buildErrorState(context, message),
          permissionDenied: () => _buildPermissionDeniedState(context),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 120.h,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    PrayerTimesModel prayerTimes,
  ) {
    final prayers = prayerTimes.getAllPrayers();
    // Filter out Sunrise (Shurooq) - typically not shown in main prayer times
    final mainPrayers = prayers
        .where((p) => p.type != PrayerType.sunrise)
        .toList();
    final nextPrayer = prayerTimes.getNextPrayer();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: mainPrayers.map((prayer) {
          final isNext = nextPrayer.type == prayer.type;
          final hasPassed = prayerTimes.hasPassed(prayer.type);

          return _buildPrayerTimeItem(
            context: context,
            name: prayer.name,
            time: _formatTime(prayer.time),
            type: prayer.type,
            isNext: isNext,
            hasPassed: hasPassed,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrayerTimeItem({
    required BuildContext context,
    required String name,
    required String time,
    required PrayerType type,
    required bool isNext,
    required bool hasPassed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Prayer Icon with gradient background
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _getGradientForPrayer(type, isNext, hasPassed),
            border: isNext
                ? Border.all(color: AppColors.primary, width: 2.5)
                : null,
            boxShadow: isNext
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(child: _getPrayerIcon(type)),
        ),
        SizedBox(height: 8.h),
        // Prayer Time
        Text(
          time,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
            color: isNext
                ? AppColors.primary
                : hasPassed
                ? Theme.of(context).textTheme.bodySmall?.color
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 2.h),
        // Prayer Name
        Text(
          name,
          style: AppTextStyles.caption.copyWith(
            color: isNext
                ? AppColors.primary
                : hasPassed
                ? Theme.of(context).textTheme.bodySmall?.color
                : Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 11.sp,
            fontFamily: 'Amiri',
          ),
        ),
      ],
    );
  }

  LinearGradient _getGradientForPrayer(
    PrayerType type,
    bool isNext,
    bool hasPassed,
  ) {
    if (hasPassed && !isNext) {
      // Gray gradient for passed prayers
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.grey.shade300, Colors.grey.shade400],
      );
    }

    // Color gradients based on prayer time
    switch (type) {
      case PrayerType.fajr:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        );
      case PrayerType.dhuhr:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDB44B), Color(0xFFF59E0B)],
        );
      case PrayerType.asr:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF97316), Color(0xFFEA580C)],
        );
      case PrayerType.maghrib:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
        );
      case PrayerType.isha:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
        );
    }
  }

  Widget _getPrayerIcon(PrayerType type) {
    IconData iconData;

    switch (type) {
      case PrayerType.fajr:
        iconData = Icons.wb_twilight;
        break;
      case PrayerType.sunrise:
        iconData = Icons.wb_sunny;
        break;
      case PrayerType.dhuhr:
        iconData = Icons.wb_sunny_outlined;
        break;
      case PrayerType.asr:
        iconData = Icons.wb_cloudy;
        break;
      case PrayerType.maghrib:
        iconData = Icons.nights_stay;
        break;
      case PrayerType.isha:
        iconData = Icons.dark_mode;
        break;
    }

    return Icon(iconData, color: Colors.white, size: 26.w);
  }

  String _formatTime(DateTime time) {
    final formatter = DateFormat('h:mm', 'en');
    return formatter.format(time);
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.orange.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'تعذر تحميل مواقيت الصلاة',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.orange.shade900,
                fontFamily: 'Amiri',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<PrayerTimesCubit>().loadPrayerTimes();
            },
            child: Text(
              'إعادة المحاولة',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedState(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off_rounded, color: Colors.blue, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'يحتاج التطبيق إلى إذن الموقع لعرض مواقيت الصلاة',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.blue.shade900,
                fontFamily: 'Amiri',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<PrayerTimesCubit>().requestPermissionAndLoad();
            },
            child: Text(
              'السماح',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
