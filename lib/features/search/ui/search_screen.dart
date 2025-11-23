import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/routing/app_router.dart';
import '../logic/cubit/search_cubit.dart';
import '../logic/cubit/search_state.dart';
import 'widgets/empty_search_state.dart';
import 'widgets/ayah_search_result_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounce?.cancel();

    // Start new timer - wait 300ms after user stops typing
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<SearchCubit>().searchSurahs(query);
      }
    });
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
                    // Back button and title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'البحث في القرآن',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Amiri',
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'ابحث عن آية أو كلمة',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.white.withOpacity(0.9),
                                  fontFamily: 'Amiri',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Modern Search Bar
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).shadowColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontFamily: 'Amiri',
                        ),
                        decoration: InputDecoration(
                          hintText: 'اكتب كلمة أو جزء من آية...',
                          hintStyle: TextStyle(
                            fontSize: 15.sp,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontFamily: 'Amiri',
                          ),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: AppColors.primary,
                            size: 24.w,
                          ),
                          suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _searchController,
                            builder: (context, value, _) {
                              return value.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: AppColors.textSecondary,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        _debounce?.cancel();
                                        context
                                            .read<SearchCubit>()
                                            .clearSearch();
                                      },
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Results
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const EmptySearchState(isNoResults: false),
                    loading: () => const AppLoadingIndicator(),
                    success: (results) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Results count header
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                          child: Text(
                            'تم العثور على ${results.length} آية',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                        // Results list
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final result = results[index];

                              // All results are Ayahs now
                              return RepaintBoundary(
                                key: ValueKey(
                                  'sr_${result.surah.number}_${result.ayah?.numberInSurah ?? 0}',
                                ),
                                child: AyahSearchResultItem(
                                  result: result,
                                  onTap: () {
                                    context.pushNamed(
                                      Routes.surahReaderScreen,
                                      arguments: SurahReaderArgs(
                                        surahNumber: result.surah.number,
                                        surahName: result.surah.name,
                                        initialPage: result.ayah?.page,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    empty: () => const EmptySearchState(isNoResults: true),
                    error: (message) => Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 60.sp,
                                color: AppColors.error,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                  fontFamily: 'Amiri',
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
