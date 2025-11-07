import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../home/data/models/surah_detail_response.dart';

class AyahCard extends StatelessWidget {
  final Ayah ayah;
  final String surahName;

  const AyahCard({super.key, required this.ayah, required this.surahName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ayah Text
        Text(
          ayah.text,
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.quranArabic,
        ),

        SizedBox(height: 16.h),

        // Ayah Info Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Ayah Number Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.primaryLight.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'آية',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontFamily: 'Amiri',
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    ayah.numberInSurah.toArabicNumber,
                    style: AppTextStyles.ayahNumber.copyWith(fontSize: 16.sp),
                  ),
                ],
              ),
            ),

            // Actions
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.copy,
                  onTap: () => _copyAyah(context),
                  tooltip: 'نسخ',
                ),
                SizedBox(width: 8.w),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  onTap: () => _shareAyah(context),
                  tooltip: 'مشاركة',
                ),
                SizedBox(width: 8.w),
                _buildActionButton(
                  icon: Icons.bookmark_border,
                  onTap: () => _bookmarkAyah(context),
                  tooltip: 'حفظ',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.w, color: AppColors.primary),
        ),
      ),
    );
  }

  void _copyAyah(BuildContext context) {
    final text = _formatAyahText();

    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20.w),
              SizedBox(width: 12.w),
              Text(
                'تم نسخ الآية',
                style: TextStyle(fontFamily: 'Amiri', fontSize: 16.sp),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _shareAyah(BuildContext context) {
    final text = _formatAyahText();

    Share.share(text, subject: 'آية من القرآن الكريم');
  }

  void _bookmarkAyah(BuildContext context) {
    // TODO: Implement bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.bookmark, color: Colors.white, size: 20.w),
            SizedBox(width: 12.w),
            Text(
              'ميزة الحفظ قريباً',
              style: TextStyle(fontFamily: 'Amiri', fontSize: 16.sp),
            ),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatAyahText() {
    return '''
${ayah.text}

﴿ $surahName - آية ${ayah.numberInSurah.toArabicNumber} ﴾

صفحة ${ayah.page.toArabicNumber} | جزء ${ayah.juz.toArabicNumber}
''';
  }
}
