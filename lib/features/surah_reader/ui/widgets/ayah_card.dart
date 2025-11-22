import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/features/quran/data/models/surah_detail_response.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/di/dependency_injection.dart';

class AyahCard extends StatelessWidget {
  final Ayah ayah;
  final String surahName;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final bool isFirstAyahOfSurah;
  final int surahNumber;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.surahName,
    this.isBookmarked = false,
    required this.onBookmarkToggle,
    this.isFirstAyahOfSurah = false,
    required this.surahNumber,
  });

  double _getFontSize() {
    final fontSize = getIt<SharedPrefHelper>().getFontSize();
    switch (fontSize) {
      case 'small':
        return 22.sp;
      case 'medium':
        return 28.sp;
      case 'large':
        return 34.sp;
      case 'xlarge':
        return 40.sp;
      default:
        return 28.sp;
    }
  }

  String _getAyahText() {
    String text = ayah.text;

    // Remove Bismillah from the first ayah ONLY if:
    // 1. It's the first ayah of the surah
    // 2. It's NOT Surah 1 (Al-Fatiha) - where Bismillah IS the first ayah
    // 3. It's NOT Surah 9 (At-Tawbah) - which has no Bismillah
    // This is because we show a separate BismillahHeader card
    if (isFirstAyahOfSurah && surahNumber != 1 && surahNumber != 9) {
      // Use regex to match Bismillah with flexible Unicode variations
      // This handles different hamzas, tashkeel, and spacing
      final bismillahRegex = RegExp(
        r'^بِسْمِ\s+ا?[لٱ]لَّهِ\s+ا?[لٱ]رَّحْمَ[ٰـَ]نِ\s+ا?[لٱ]رَّحِيمِ\s*',
        unicode: true,
      );

      if (bismillahRegex.hasMatch(text)) {
        text = text.replaceFirst(bismillahRegex, '').trim();
      } else {
        // Fallback to exact string matching for any edge cases
        const bismillahPatterns = [
          'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          'بسم الله الرحمن الرحيم',
        ];

        for (var pattern in bismillahPatterns) {
          if (text.startsWith(pattern)) {
            text = text.substring(pattern.length).trim();
            break;
          }
        }
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ayah Text
        Text(
          _getAyahText(),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.quranArabic.copyWith(
            fontSize: _getFontSize(),
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
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
                  icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  onTap: onBookmarkToggle,
                  tooltip: isBookmarked ? 'إزالة الحفظ' : 'حفظ',
                  isActive: isBookmarked,
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
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.w,
            color: isActive ? AppColors.primary : AppColors.primary,
          ),
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

  String _formatAyahText() {
    return '''
${ayah.text}

﴿ $surahName - آية ${ayah.numberInSurah.toArabicNumber} ﴾

صفحة ${ayah.page.toArabicNumber} | جزء ${ayah.juz.toArabicNumber}
''';
  }
}
