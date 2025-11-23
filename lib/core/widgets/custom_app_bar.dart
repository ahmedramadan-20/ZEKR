import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool useGradient;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.useGradient = true,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 100.h : 80.h);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: useGradient ? AppColors.getPrimaryGradient(context) : null,
        color: useGradient
            ? null
            : (backgroundColor ?? Theme.of(context).scaffoldBackgroundColor),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: useGradient
                ? AppColors.primary.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: Row(
            children: [
              // Back Button
              if (showBackButton)
                Container(
                  decoration: BoxDecoration(
                    color: useGradient
                        ? Colors.white.withOpacity(isDark ? 0.12 : 0.2)
                        : (isDark
                              ? Colors.white.withOpacity(0.08)
                              : AppColors.primary.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: useGradient
                          ? Colors.white
                          : (isDark ? Colors.white : AppColors.primary),
                      size: 20.w,
                    ),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                    padding: EdgeInsets.all(8.w),
                    constraints: const BoxConstraints(),
                  ),
                ),
              if (showBackButton) SizedBox(width: 16.w),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: useGradient
                            ? Colors.white
                            : (isDark ? Colors.white : AppColors.textPrimary),
                        fontFamily: 'Amiri',
                        height: 1.1,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: useGradient
                              ? Colors.white.withOpacity(0.9)
                              : (isDark
                                    ? Colors.white70
                                    : AppColors.textSecondary),
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              if (actions != null)
                ...actions!.map(
                  (action) => Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: useGradient
                            ? Colors.white.withOpacity(0.2)
                            : (isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : AppColors.primary.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: action,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
