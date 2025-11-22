import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../logic/cubit/bookmarks_cubit.dart';
import '../logic/cubit/bookmarks_state.dart';
import 'widgets/bookmark_item.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'المفضلة',
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
            fontFamily: 'Amiri',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<BookmarksCubit, BookmarksState>(
            builder: (context, state) {
              return state.maybeWhen(
                success: (bookmarks) => bookmarks.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.delete_sweep,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showClearAllDialog(context);
                        },
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BookmarksCubit, BookmarksState>(
        builder: (context, state) {
          return state.when(
            initial: () => const AppLoadingIndicator(),
            loading: () => const AppLoadingIndicator(),
            success: (bookmarks) => ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return RepaintBoundary(
                  key: ValueKey('bm_${bookmark['surahNumber']}_${bookmark['ayahNumber']}'),
                  child: BookmarkItem(
                    bookmark: bookmark,
                    onTap: () {
                      // Navigate to surah reader at exact page
                      context.pushNamed(
                        Routes.surahReaderScreen,
                        arguments: SurahReaderArgs(
                          surahNumber: bookmark['surahNumber'] as int,
                          surahName: bookmark['surahName'] as String,
                          initialPage: bookmark['pageNumber'] as int?,
                        ),
                      );
                    },
                    onDelete: () {
                      _showDeleteDialog(
                        context,
                        bookmark['surahNumber'] as int,
                        bookmark['ayahNumber'] as int,
                        bookmark['surahName'] as String,
                      );
                    },
                  ),
                );
              },
            ),
            empty: () => _buildEmptyState(context),
            error: (message) => Center(
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
                      style: Theme.of(context).textTheme.bodyLarge,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 100.sp,
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withOpacity(0.3),
            ),
            SizedBox(height: 24.h),
            Text(
              'لا توجد مفضلة',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontFamily: 'Amiri'),
            ),
            SizedBox(height: 12.h),
            Text(
              'يمكنك إضافة آيات للمفضلة من شاشة قراءة السورة',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    int surahNumber,
    int ayahNumber,
    String surahName,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'حذف من المفضلة؟',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontFamily: 'Amiri'),
        ),
        content: Text(
          'هل تريد حذف $surahName - آية $ayahNumber من المفضلة؟',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: Theme.of(context).textTheme.bodyLarge),
          ),
          TextButton(
            onPressed: () {
              context.read<BookmarksCubit>().removeBookmark(
                surahNumber,
                ayahNumber,
              );
              Navigator.pop(dialogContext);
            },
            child: Text(
              'حذف',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'حذف جميع المفضلة؟',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontFamily: 'Amiri'),
        ),
        content: Text(
          'هل تريد حذف جميع الآيات من المفضلة؟ لا يمكن التراجع عن هذا الإجراء.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: Theme.of(context).textTheme.bodyLarge),
          ),
          TextButton(
            onPressed: () {
              context.read<BookmarksCubit>().clearAllBookmarks();
              Navigator.pop(dialogContext);
            },
            child: Text(
              'حذف الكل',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
