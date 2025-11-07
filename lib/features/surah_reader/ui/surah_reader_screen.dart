import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../logic/cubit/surah_reader_cubit.dart';
import '../logic/cubit/surah_reader_state.dart';
import 'widgets/ayah_card.dart';
import 'widgets/bismillah_header.dart';
import 'widgets/page_indicator.dart';
import 'widgets/surah_header.dart';

class SurahReaderScreen extends StatelessWidget {
  final int surahNumber;
  final String surahName;

  const SurahReaderScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SurahReaderCubit>();
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(
          surahName,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Add bookmark
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareSurah(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<SurahReaderCubit, SurahReaderState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const AppLoadingIndicator(),
            success: (surahDetail, currentPage, currentPageAyahs) {
              final isFirstPage = currentPage == surahDetail.ayahs.first.page;
              final showBismillah =
                  isFirstPage && surahNumber != 1 && surahNumber != 9;

              return GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    cubit.nextPage();
                  } else if (details.primaryVelocity! > 0) {
                    cubit.previousPage();
                  }
                },
                child: Column(
                  children: [
                    // Page Indicator
                    PageIndicator(
                      currentPage: currentPage,
                      juzNumber: currentPageAyahs.first.juz,
                      onPrevious: cubit.canGoPrevious
                          ? () => cubit.previousPage()
                          : null,
                      onNext: cubit.canGoNext ? () => cubit.nextPage() : null,
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Surah Header (only on first page)
                            if (isFirstPage)
                              SurahHeader(
                                surahName: surahDetail.name,
                                surahNameEnglish: surahDetail.englishName,
                                revelationType: surahDetail.revelationType,
                                numberOfAyahs: surahDetail.numberOfAyahs,
                              ),

                            // Bismillah (only on first page, except Al-Fatiha & At-Tawbah)
                            if (showBismillah) const BismillahHeader(),

                            // Ayahs
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
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
                                        ayah: ayah,
                                        surahName: surahDetail.name,
                                      ),
                                      if (index < currentPageAyahs.length - 1)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Divider(
                                                  color: AppColors.divider,
                                                  thickness: 1,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                ),
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 6.w,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  color: AppColors.divider,
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
              onRetry: () =>
                  context.read<SurahReaderCubit>().loadSurah(surahNumber),
            ),
          );
        },
      ),
    );
  }

  void _shareSurah(BuildContext context) {
    final state = context.read<SurahReaderCubit>().state;
    state.maybeWhen(
      success: (surahDetail, currentPage, currentPageAyahs) {
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
