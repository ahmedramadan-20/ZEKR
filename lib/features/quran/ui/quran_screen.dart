import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../logic/cubit/quran_cubit.dart';
import '../logic/cubit/quran_state.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/surah_list_item.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  // REMOVED: initState - getSurahList() is already called in BlocProvider.create in app_router.dart
  // This prevents double initialization and race conditions

  @override
  void dispose() {
    // BlocProvider automatically disposes the cubit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Gradient Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.getPrimaryGradient(context),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Actions
                    Row(
                      children: [
                        // Back button (if can pop)
                        if (Navigator.of(context).canPop())
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        if (Navigator.of(context).canPop())
                          SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'القرآن الكريم',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            context.pushNamed(Routes.searchScreen);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.pushNamed(Routes.settingsScreen);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Surah List
            Expanded(
              child: BlocBuilder<QuranCubit, QuranState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const AppLoadingIndicator(),
                    downloading: (current, total) =>
                        const AppLoadingIndicator(),
                    success:
                        (
                          surahs,
                          isDownloadingInBackground,
                          downloadProgress,
                          totalToDownload,
                          lastSurahNumber,
                          lastPageNumber,
                        ) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              await context
                                  .read<QuranCubit>()
                                  .refreshSurahList();
                            },
                            child: CustomScrollView(
                              slivers: [
                                // Download Progress Banner
                                if (isDownloadingInBackground &&
                                    downloadProgress != null &&
                                    totalToDownload != null)
                                  SliverToBoxAdapter(
                                    child: Container(
                                      margin: EdgeInsets.all(16.w),
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.cloud_download_rounded,
                                                color: Colors.white,
                                                size: 20.w,
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  'جاري تحميل تفاصيل السور في الخلفية',
                                                  style: TextStyle(
                                                    fontFamily: 'Amiri',
                                                    fontSize: 14.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12.h),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                            child: LinearProgressIndicator(
                                              value:
                                                  downloadProgress /
                                                  totalToDownload,
                                              minHeight: 6.h,
                                              backgroundColor: Colors.white24,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                    Color
                                                  >(Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'سورة $downloadProgress من $totalToDownload',
                                            style: TextStyle(
                                              fontFamily: 'Amiri',
                                              fontSize: 12.sp,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Continue Reading Card
                                if (lastSurahNumber != null &&
                                    lastPageNumber != null &&
                                    surahs.any(
                                      (s) => s.number == lastSurahNumber,
                                    ))
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        16.w,
                                        16.h,
                                        16.w,
                                        8.h,
                                      ),
                                      child: ContinueReadingCard(
                                        surahNumber: lastSurahNumber,
                                        surahName: surahs
                                            .firstWhere(
                                              (s) =>
                                                  s.number == lastSurahNumber,
                                            )
                                            .name,
                                        pageNumber: lastPageNumber,
                                        onTap: () async {
                                          await context.pushNamed(
                                            Routes.surahReaderScreen,
                                            arguments: SurahReaderArgs(
                                              surahNumber: lastSurahNumber,
                                              surahName: surahs
                                                  .firstWhere(
                                                    (s) =>
                                                        s.number ==
                                                        lastSurahNumber,
                                                  )
                                                  .name,
                                              initialPage: lastPageNumber,
                                            ),
                                          );
                                          // Update last read position when returning
                                          if (mounted) {
                                            context
                                                .read<QuranCubit>()
                                                .updateLastReadPosition();
                                          }
                                        },
                                      ),
                                    ),
                                  ),

                                // Section Title
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      24.w,
                                      16.h,
                                      24.w,
                                      12.h,
                                    ),
                                    child: Text(
                                      'السور',
                                      style: AppTextStyles.titleLarge.copyWith(
                                        fontFamily: 'Amiri',
                                        color: Theme.of(
                                          context,
                                        ).textTheme.titleLarge?.color,
                                      ),
                                    ),
                                  ),
                                ),

                                // Surahs List
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      final surah = surahs[index];
                                      final isLastRead =
                                          lastSurahNumber != null &&
                                          surah.number == lastSurahNumber;
                                      return RepaintBoundary(
                                        key: ValueKey('surah_${surah.number}'),
                                        child: SurahListItem(
                                          surah: surah,
                                          isLastRead: isLastRead,
                                          onTap: () async {
                                            await context.pushNamed(
                                              Routes.surahReaderScreen,
                                              arguments: SurahReaderArgs(
                                                surahNumber: surah.number,
                                                surahName: surah.name,
                                              ),
                                            );
                                            // Update last read position when returning
                                            if (mounted) {
                                              context
                                                  .read<QuranCubit>()
                                                  .updateLastReadPosition();
                                            }
                                          },
                                        ),
                                      );
                                    }, childCount: surahs.length),
                                  ),
                                ),

                                // Bottom Padding
                                SliverToBoxAdapter(
                                  child: SizedBox(height: 16.h),
                                ),
                              ],
                            ),
                          );
                        },
                    error: (message) => AppErrorWidget(
                      message: message,
                      onRetry: () => context.read<QuranCubit>().getSurahList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
