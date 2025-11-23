import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';

import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../logic/cubit/prayer_times_cubit.dart';
import '../logic/cubit/prayer_times_state.dart';
import 'widgets/prayer_time_card.dart';
import 'widgets/next_prayer_card.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'مواقيت الصلاة',
        useGradient: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              context.read<PrayerTimesCubit>().refresh();
            },
          ),
        ],
      ),
      body: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
        builder: (context, state) {
          return state.when(
            initial: () => const AppLoadingIndicator(),
            loading: () => const AppLoadingIndicator(),
            success: (prayerTimes) {
              final nextPrayer = prayerTimes.getNextPrayer();
              final allPrayers = prayerTimes.getAllPrayers();

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<PrayerTimesCubit>().refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Next Prayer Card
                      NextPrayerCard(nextPrayer: nextPrayer),

                      SizedBox(height: 32.h),

                      // Location Info
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            size: 20.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            prayerTimes.locationName,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Date
                      Text(
                        _formatDate(prayerTimes.date),
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontFamily: 'Amiri'),
                      ),

                      SizedBox(height: 24.h),

                      // All Prayer Times
                      ...allPrayers.map((prayer) {
                        final hasPassed = prayerTimes.hasPassed(prayer.type);
                        final isNext = nextPrayer.type == prayer.type;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: PrayerTimeCard(
                            prayer: prayer,
                            hasPassed: hasPassed,
                            isNext: isNext,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
            error: (message) => AppErrorWidget(
              message: message,
              onRetry: () {
                context.read<PrayerTimesCubit>().loadPrayerTimes();
              },
            ),
            permissionDenied: () => Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off_rounded,
                      size: 80.w,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'نحتاج إلى إذن الموقع',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontFamily: 'Amiri'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'للحصول على أوقات الصلاة الدقيقة، نحتاج إلى معرفة موقعك',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<PrayerTimesCubit>()
                            .requestPermissionAndLoad();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'السماح بالوصول إلى الموقع',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format in Arabic
    final formatter = DateFormat('EEEE، d MMMM yyyy', 'ar');
    return formatter.format(date);
  }
}
