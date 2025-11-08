import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../logic/cubit/home_cubit.dart';
import '../logic/cubit/home_state.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/surah_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  @override
  void initState() {
    super.initState();
    // Load surah list immediately, it will handle background downloads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getSurahList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'القرآن الكريم',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.pushNamed(Routes.searchScreen);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.pushNamed(Routes.settingsScreen);
            },
          ),
          // Debug button to reset download status
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final sharedPref = getIt<SharedPrefHelper>();
              await sharedPref.setAllSurahsDownloaded(false);
              await sharedPref.setDownloadProgress(0);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم إعادة تعيين حالة التحميل',
                      style: TextStyle(fontFamily: 'Amiri', fontSize: 16.sp),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );

                // Retry loading
                context.read<HomeCubit>().getSurahList();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const AppLoadingIndicator(),
            downloading: (current, total) => const AppLoadingIndicator(),
            success:
                (
                  surahs,
                  isDownloadingInBackground,
                  downloadProgress,
                  totalToDownload,
                ) {
                  final sharedPrefHelper = getIt<SharedPrefHelper>();
                  final lastSurahNumber = sharedPrefHelper.getLastReadSurah();
                  final lastPageNumber = sharedPrefHelper.getLastReadPage();

                  // Show download progress notification
                  if (isDownloadingInBackground &&
                      downloadProgress != null &&
                      totalToDownload != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'جاري تحميل تفاصيل السور في الخلفية',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 14.sp,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: downloadProgress / totalToDownload,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$downloadProgress من $totalToDownload',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 12.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    });
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<HomeCubit>().refreshSurahList();
                    },
                    child: CustomScrollView(
                      slivers: [
                        // Continue Reading Card
                        if (lastSurahNumber != null &&
                            lastPageNumber != null &&
                            surahs.any((s) => s.number == lastSurahNumber))
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
                                      (s) => s.number == lastSurahNumber,
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
                                            (s) => s.number == lastSurahNumber,
                                          )
                                          .name,
                                    ),
                                  );
                                  // Refresh the list to update continue reading card
                                  if (mounted) {
                                    context
                                        .read<HomeCubit>()
                                        .refreshSurahList();
                                  }
                                },
                              ),
                            ),
                          ),

                        // Section Title
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              16.w,
                              16.h,
                              16.w,
                              12.h,
                            ),
                            child: Text(
                              'السور',
                              style: AppTextStyles.surahNameArabic.copyWith(
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                        ),

                        // Surahs List
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final surah = surahs[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: SurahListItem(
                                  surah: surah,
                                  onTap: () async {
                                    context.pushNamed(
                                      Routes.surahReaderScreen,
                                      arguments: SurahReaderArgs(
                                        surahNumber: surah.number,
                                        surahName: surah.name,
                                      ),
                                    );
                                    // Refresh the list to update continue reading card
                                    if (mounted) {
                                      context
                                          .read<HomeCubit>()
                                          .refreshSurahList();
                                    }
                                  },
                                ),
                              );
                            }, childCount: surahs.length),
                          ),
                        ),

                        // Bottom Padding
                        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                      ],
                    ),
                  );
                },
            error: (message) => AppErrorWidget(
              message: message,
              onRetry: () => context.read<HomeCubit>().getSurahList(),
            ),
          );
        },
      ),
    );
  }
}
