import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_text_styles.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? imagePath;
  final Color color;
  final VoidCallback? onTap;
  final bool isComingSoon;

  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.imagePath,
    required this.color,
    required this.onTap,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(isComingSoon ? 0.3 : 0.8),
                color.withOpacity(isComingSoon ? 0.2 : 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null || imagePath != null)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: imagePath != null
                          ? Image.asset(
                              imagePath!,
                              width: 32.w,
                              height: 32.w,
                              color: color,
                            )
                          : Icon(icon, size: 32.w, color: color),
                    ),
                  const Spacer(),
                  if (isComingSoon)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'قريباً',
                        style: AppTextStyles.caption.copyWith(
                          fontFamily: 'Amiri',
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: AppTextStyles.surahNameArabic.copyWith(
                  fontSize: 22.sp,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontFamily: 'Amiri',
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
