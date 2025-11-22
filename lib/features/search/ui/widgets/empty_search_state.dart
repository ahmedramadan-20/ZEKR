import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';

class EmptySearchState extends StatelessWidget {
  final bool isNoResults;

  const EmptySearchState({super.key, this.isNoResults = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNoResults ? Icons.search_off : Icons.search,
              size: 80.sp,
              color: AppColors.primary.withOpacity(0.3),
            ),
            SizedBox(height: 24.h),
            Text(
              isNoResults ? 'لا توجد نتائج' : 'ابحث في آيات القرآن',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              isNoResults
                  ? 'حاول البحث بكلمات مختلفة أو تأكد من كتابة النص بشكل صحيح'
                  : 'اكتب كلمة أو جزء من آية للبحث عنها في القرآن الكريم',
              style: TextStyle(
                fontSize: 15.sp,
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withOpacity(0.8),
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.center,
            ),
            if (!isNoResults) ...[
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Text(
                      'أمثلة للبحث:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildExample(context, 'بسم الله'),
                    SizedBox(height: 8.h),
                    _buildExample(context, 'الحمد لله'),
                    SizedBox(height: 8.h),
                    _buildExample(context, 'رب العالمين'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExample(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 16.sp,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontFamily: 'Amiri',
            ),
          ),
        ],
      ),
    );
  }
}
