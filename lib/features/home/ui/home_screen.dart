import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/di/dependency_injection.dart';
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
import 'widgets/download_dialog.dart';
import 'widgets/surah_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    // Check if we need to download all surahs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndDownloadSurahs();
    });
  }

  void _checkAndDownloadSurahs() async {
    if (_dialogShown) return;

    final sharedPref = getIt<SharedPrefHelper>();
    final isDownloaded = sharedPref.isAllSurahsDownloaded();

    print('=== Download Check ===');
    print('Is all surahs downloaded: $isDownloaded');

    if (!isDownloaded) {
      print('Showing download dialog...');
      _dialogShown = true;
      _showDownloadDialog();
    } else {
      print('All surahs already downloaded');
    }
  }

  void _showDownloadDialog() {
    final cubit = context.read<HomeCubit>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider<HomeCubit>.value(
        value: cubit,
        child: const DownloadDialog(),
      ),
    );
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
              Navigator.pushNamed(context, Routes.searchScreen);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, Routes.settingsScreen);
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

                // Restart the check
                _dialogShown = false;
                _checkAndDownloadSurahs();
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
            success: (surahs) {
              final sharedPrefHelper = getIt<SharedPrefHelper>();
              final lastSurahNumber = sharedPrefHelper.getLastReadSurah();
              final lastPageNumber = sharedPrefHelper.getLastReadPage();

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
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                          child: ContinueReadingCard(
                            surahNumber: lastSurahNumber,
                            surahName: surahs
                                .firstWhere((s) => s.number == lastSurahNumber)
                                .name,
                            pageNumber: lastPageNumber,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
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
                            },
                          ),
                        ),
                      ),

                    // Section Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
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
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final surah = surahs[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: SurahListItem(
                              surah: surah,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.surahReaderScreen,
                                  arguments: SurahReaderArgs(
                                    surahNumber: surah.number,
                                    surahName: surah.name,
                                  ),
                                );
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
