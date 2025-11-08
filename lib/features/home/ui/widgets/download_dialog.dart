import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../logic/cubit/home_cubit.dart';
import '../../logic/cubit/home_state.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({super.key});

  @override
  State createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State {
  @override
  void initState() {
    super.initState();
    // Start downloading automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().downloadAllSurahs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            state.maybeWhen(
              success:
                  (
                    surahs,
                    isDownloadingInBackground,
                    downloadProgress,
                    totalToDownload,
                  ) {
                    // Close dialog when download is complete
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
              error: (message) {
                // Show error and close dialog
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      message,
                      style: TextStyle(fontFamily: 'Amiri', fontSize: 16.sp),
                    ),
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              downloading: (current, total) {
                final progress = current / total;
                final percentage = (progress * 100).toInt();

                return Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.download_rounded,
                          size: 48.w,
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Title
                      Text(
                        'تحميل القرآن الكريم',
                        style: AppTextStyles.surahNameArabic.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Description
                      Text(
                        'جاري تحميل جميع السور للقراءة بدون اتصال',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontFamily: 'Amiri',
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 24.h),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8.h,
                          backgroundColor: AppColors.divider,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Progress Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'سورة $current من $total',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontFamily: 'Amiri',
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Info text
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16.w,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'سيتم التحميل مرة واحدة فقط',
                                style: AppTextStyles.caption.copyWith(
                                  fontFamily: 'Amiri',
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              orElse: () => Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16.h),
                    Text(
                      'جاري التحضير...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
