import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class GradientHeader extends StatelessWidget {
  final String greeting;
  final String userName;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const GradientHeader({
    super.key,
    this.greeting = 'السلام عليكم',
    this.userName = 'أخي المسلم',
    this.onSearchTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.getPrimaryGradient(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: AppTextStyles.bodyOnGradient.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(userName, style: AppTextStyles.titleOnGradient),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onNotificationTap,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Search Bar
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSearchTap,
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: 22.w,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'ابحث عن سورة أو آية...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
