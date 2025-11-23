import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/routing/routes.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/di/dependency_injection.dart';
import '../logic/cubit/surah_reader_cubit.dart';
import '../logic/cubit/surah_reader_state.dart';
import 'widgets/ayah_card.dart';
import 'widgets/bismillah_header.dart';
import 'widgets/page_indicator.dart';
import 'widgets/surah_header.dart';

class SurahReaderScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahReaderScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  String _currentFontSize = 'medium';

  @override
  void initState() {
    super.initState();
    _loadFontSize();
    WakelockPlus.enable();
  }

  void _loadFontSize() {
    final fontSize = getIt<SharedPrefHelper>().getFontSize();
    if (_currentFontSize != fontSize) {
      setState(() {
        _currentFontSize = fontSize;
      });
    }
  }

  @override
  void didUpdateWidget(SurahReaderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadFontSize();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Font size is loaded in initState and didUpdateWidget
    // Don't call _loadFontSize() here - it causes setState on every build!

    final cubit = context.read<SurahReaderCubit>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: widget.surahName,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareSurah(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Surah Content
            Expanded(
              child: BlocBuilder<SurahReaderCubit, SurahReaderState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const AppLoadingIndicator(),
                    success: (surahDetail, currentPage, currentPageAyahs, bookmarkedAyahs) {
                      final isFirstPage =
                          currentPage == surahDetail.ayahs.first.page;
                      final showBismillah =
                          isFirstPage &&
                          widget.surahNumber != 1 &&
                          widget.surahNumber != 9;

                      return GestureDetector(
                        onHorizontalDragEnd: (details) {
                          // In RTL: swipe right (positive velocity) = next page
                          //         swipe left (negative velocity) = previous page
                          if (details.primaryVelocity! > 0) {
                            cubit.nextPage();
                            _scrollToTop();
                          } else if (details.primaryVelocity! < 0) {
                            cubit.previousPage();
                            _scrollToTop();
                          }
                        },
                        child: Column(
                          children: [
                            // Page Indicator
                            PageIndicator(
                              currentPage: currentPage,
                              juzNumber: currentPageAyahs.first.juz,
                              onPrevious: cubit.canGoPrevious
                                  ? () {
                                      cubit.previousPage();
                                      _scrollToTop();
                                    }
                                  : null,
                              onNext: cubit.canGoNext
                                  ? () {
                                      cubit.nextPage();
                                      _scrollToTop();
                                    }
                                  : null,
                            ),

                            // Content
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    // Surah Header (only on first page)
                                    if (isFirstPage)
                                      SurahHeader(
                                        surahName: surahDetail.name,
                                        surahNameEnglish:
                                            surahDetail.englishName,
                                        revelationType:
                                            surahDetail.revelationType,
                                        numberOfAyahs:
                                            surahDetail.numberOfAyahs,
                                      ),

                                    // Bismillah (only on first page, except Al-Fatiha & At-Tawbah)
                                    if (showBismillah) const BismillahHeader(),

                                    // Ayahs
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      padding: EdgeInsets.all(20.w),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(
                                              context,
                                            ).shadowColor.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: currentPageAyahs.asMap().entries.map((
                                          entry,
                                        ) {
                                          final index = entry.key;
                                          final ayah = entry.value;
                                          return Column(
                                            children: [
                                              AyahCard(
                                                key: ValueKey(
                                                  'ayah_${ayah.number}',
                                                ),
                                                ayah: ayah,
                                                surahName: surahDetail.name,
                                                surahNumber: surahDetail.number,
                                                isBookmarked: bookmarkedAyahs
                                                    .contains(
                                                      ayah.numberInSurah,
                                                    ),
                                                isFirstAyahOfSurah:
                                                    ayah.numberInSurah == 1 &&
                                                    isFirstPage,
                                                onBookmarkToggle: () {
                                                  final wasBookmarked =
                                                      bookmarkedAyahs.contains(
                                                        ayah.numberInSurah,
                                                      );
                                                  cubit.toggleBookmark(
                                                    ayah.numberInSurah,
                                                  );

                                                  // Show snackbar feedback
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        children: [
                                                          Icon(
                                                            wasBookmarked
                                                                ? Icons
                                                                      .bookmark_remove
                                                                : Icons
                                                                      .bookmark_added,
                                                            color: Colors.white,
                                                            size: 20.w,
                                                          ),
                                                          SizedBox(width: 12.w),
                                                          Text(
                                                            wasBookmarked
                                                                ? 'تم إزالة الإشارة المرجعية'
                                                                : 'تم حفظ الآية في المفضلة',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Amiri',
                                                              fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          wasBookmarked
                                                          ? AppColors.error
                                                          : AppColors.success,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                      ),
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                      action: wasBookmarked
                                                          ? null
                                                          : SnackBarAction(
                                                              label: 'عرض',
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                Navigator.of(
                                                                  context,
                                                                ).pushNamed(
                                                                  Routes
                                                                      .bookmarksScreen,
                                                                );
                                                              },
                                                            ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              if (index <
                                                  currentPageAyahs.length - 1)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 16.h,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Divider(
                                                          color: Theme.of(
                                                            context,
                                                          ).dividerColor,
                                                          thickness: 1,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12.w,
                                                            ),
                                                        child: Icon(
                                                          Icons.circle,
                                                          size: 6.w,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Divider(
                                                          color: Theme.of(
                                                            context,
                                                          ).dividerColor,
                                                          thickness: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    error: (message) => AppErrorWidget(
                      message: message,
                      onRetry: () => context.read<SurahReaderCubit>().loadSurah(
                        widget.surahNumber,
                      ),
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

  void _shareSurah(BuildContext context) {
    final state = context.read<SurahReaderCubit>().state;
    state.maybeWhen(
      success: (surahDetail, currentPage, currentPageAyahs, bookmarkedAyahs) {
        final text =
            '''
سورة ${surahDetail.name}
${surahDetail.englishName}

عدد الآيات: ${surahDetail.numberOfAyahs}
نوع السورة: ${surahDetail.revelationType == 'Meccan' ? 'مكية' : 'مدنية'}

القرآن الكريم 📖
''';
        Share.share(text, subject: 'سورة ${surahDetail.name}');
      },
      orElse: () {},
    );
  }
}
