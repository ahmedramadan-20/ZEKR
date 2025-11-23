import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/core/helpers/extensions.dart';
import 'package:quran/core/routing/routes.dart';
import 'package:quran/core/routing/app_router.dart';
import 'package:quran/core/theming/app_colors.dart';

import 'package:quran/core/di/dependency_injection.dart';
import 'package:quran/core/helpers/shared_pref_helper.dart';
import 'package:quran/features/prayer_times/logic/cubit/prayer_times_cubit.dart';
import 'widgets/gradient_header.dart';
import 'widgets/stats_card.dart';
import 'widgets/prayer_times_horizontal.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/quick_access_card.dart';
import 'widgets/action_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPrefHelper _sharedPrefHelper;
  late final PrayerTimesCubit _prayerTimesCubit;
  int _pagesReadToday = 0;
  int _bookmarkCount = 0;
  int? _lastReadSurah;
  int? _lastReadPage;
  String _lastReadSurahName = 'سورة الفاتحة'; // Default

  @override
  void initState() {
    super.initState();
    _sharedPrefHelper = getIt<SharedPrefHelper>();
    _prayerTimesCubit = getIt<PrayerTimesCubit>()..loadPrayerTimes();
    _loadStats();
  }

  @override
  void dispose() {
    // Clean up any pending operations
    _prayerTimesCubit.close();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final pagesRead = _sharedPrefHelper.getDailyPagesRead();
    final bookmarks = _sharedPrefHelper.getBookmarksList().length;
    final lastSurah = _sharedPrefHelper.getLastReadSurah();
    final lastPage = _sharedPrefHelper.getLastReadPage();
    final lastSurahName = _sharedPrefHelper.getLastReadSurahName();

    // Use cached name or default
    final surahName = lastSurahName ?? 'سورة الفاتحة';

    // Early return if widget is no longer mounted
    if (!mounted) return;

    setState(() {
      _pagesReadToday = pagesRead;
      _bookmarkCount = bookmarks;
      _lastReadSurah = lastSurah;
      _lastReadPage = lastPage;
      _lastReadSurahName = surahName;
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _prayerTimesCubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Gradient Header with Search
              GradientHeader(
                greeting: 'السلام عليكم',
                userName: 'أخي المسلم',
                onSearchTap: () async {
                  await context.pushNamed(Routes.searchScreen);
                  _loadStats();
                },
                onNotificationTap: () {
                  // TODO: Implement notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'ميزة الإشعارات قريبًا',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontFamily: 'Amiri',
                        ),
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                },
              ),

              // Prayer Times Horizontal
              const PrayerTimesHorizontal(),

              // Main Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadStats();
                    await context.read<PrayerTimesCubit>().refresh();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Daily Stats Section
                        Text(
                          'إحصائيات اليوم',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.h),

                        Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                title: 'القراءة اليومية',
                                value: '$_pagesReadToday',
                                subtitle: 'صفحة',
                                icon: Icons.menu_book_rounded,
                                gradientStart:
                                    AppColors.getStatsGradient1Colors(
                                      context,
                                    )[0],
                                gradientEnd: AppColors.getStatsGradient1Colors(
                                  context,
                                )[1],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: StatsCard(
                                title: 'الإشارات المرجعية',
                                value: '$_bookmarkCount',
                                subtitle: _bookmarkCount == 1 ? 'آية' : 'آيات',
                                icon: Icons.bookmark_rounded,
                                gradientStart:
                                    AppColors.getStatsGradient2Colors(
                                      context,
                                    )[0],
                                gradientEnd: AppColors.getStatsGradient2Colors(
                                  context,
                                )[1],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Continue Reading Card
                        if (_lastReadSurah != null && _lastReadPage != null)
                          ContinueReadingCard(
                            surahName: _lastReadSurahName,
                            pageNumber: _lastReadPage!,
                            onTap: () async {
                              await context.pushNamed(
                                Routes.surahReaderScreen,
                                arguments: SurahReaderArgs(
                                  surahNumber: _lastReadSurah!,
                                  surahName: _lastReadSurahName,
                                  initialPage: _lastReadPage,
                                ),
                              );
                              _loadStats();
                            },
                          ),

                        SizedBox(height: 24.h),

                        // Prayer Times Quick Access
                        QuickAccessCard(
                          title: 'مواقيت الصلاة الكاملة',
                          subtitle: 'اطلع على جميع أوقات الصلاة والتفاصيل',
                          icon: Icons.access_time_rounded,
                          gradientStart: AppColors.getQuickAccessGradientColors(
                            context,
                          )[0],
                          gradientEnd: AppColors.getQuickAccessGradientColors(
                            context,
                          )[1],
                          onTap: () =>
                              context.pushNamed(Routes.prayerTimesScreen),
                        ),

                        SizedBox(height: 32.h),

                        // Quick Actions
                        Text(
                          'استكشف',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.h),

                        // Action Cards Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: 1.0,
                          children: [
                            ActionCard(
                              title: 'القرآن الكريم',
                              subtitle: 'قراءة وتدبر',
                              icon: Icons.menu_book_rounded,
                              color: AppColors.primary,
                              onTap: () async {
                                await context.pushNamed(Routes.quranScreen);
                                _loadStats();
                              },
                            ),
                            ActionCard(
                              title: 'البحث',
                              subtitle: 'ابحث في القرآن',
                              icon: Icons.search_rounded,
                              color: AppColors.secondary,
                              onTap: () async {
                                await context.pushNamed(Routes.searchScreen);
                                _loadStats();
                              },
                            ),
                            ActionCard(
                              title: 'المفضلة',
                              subtitle: 'الآيات المحفوظة',
                              icon: Icons.bookmark_rounded,
                              color: AppColors.accent,
                              onTap: () async {
                                await context.pushNamed(Routes.bookmarksScreen);
                                _loadStats();
                              },
                            ),
                            ActionCard(
                              title: 'الإعدادات',
                              subtitle: 'إعدادات التطبيق',
                              icon: Icons.settings_rounded,
                              color: AppColors.juzBadge,
                              onTap: () async {
                                await context.pushNamed(Routes.settingsScreen);
                                _loadStats();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
