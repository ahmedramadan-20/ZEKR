import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int juzNumber;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.juzNumber,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous Button
          _buildNavigationButton(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: onPrevious,
            isEnabled: onPrevious != null,
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Page Number
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_stories,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 18.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        currentPage.toArabicNumber,
                        style: AppTextStyles.pageInfo.copyWith(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                // Juz Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.juzBadge.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.juzBadge.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'جزء',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.juzBadge,
                          fontFamily: 'Amiri',
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        juzNumber.toArabicNumber,
                        style: AppTextStyles.juzInfo.copyWith(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Next Button
          _buildNavigationButton(
            icon: Icons.arrow_forward_ios_rounded,
            onPressed: onNext,
            isEnabled: onNext != null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isEnabled
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.divider.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: isEnabled
            ? AppColors.primary
            : AppColors.textSecondary.withOpacity(0.5),
        iconSize: 20.w,
      ),
    );
  }
}
