import 'package:flutter/material.dart';

import '../../../../core/theming/app_text_styles.dart';

class ContinueReadingCard extends StatelessWidget {
  final int surahNumber;
  final String surahName;
  final int pageNumber;
  final VoidCallback onTap;

  const ContinueReadingCard({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.pageNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Theme.of(context).shadowColor.withOpacity(0.07),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'تابع القراءة من $surahName\n(صفحة $pageNumber)',
                style: AppTextStyles.surahNameArabic.copyWith(fontSize: 18),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}
