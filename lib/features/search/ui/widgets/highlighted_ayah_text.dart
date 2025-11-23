import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/arabic_utils.dart';

class HighlightedAyahText extends StatelessWidget {
  final String text;
  final String query;

  const HighlightedAyahText({super.key, required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return Text(
        text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.sp,
          height: 1.8,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontFamily: 'Amiri',
        ),
        textDirection: TextDirection.rtl,
      );
    }

    final normalizedText = ArabicUtils.normalizeForSearch(text);
    final normalizedQuery = ArabicUtils.normalizeForSearch(query);

    final spans = <TextSpan>[];

    int currentOrig = 0;
    int currentNorm = 0;

    // Simple mapping by scanning original and normalized in parallel
    // Build a mapping from normalized index to original index by stripping chars
    final mapIndexes = <int, int>{};
    for (int i = 0, j = 0; i < text.length; i++) {
      final ch = text[i];
      final normCh = ArabicUtils.normalizeForSearch(ch);
      if (normCh.isNotEmpty) {
        mapIndexes[j] = i;
        j += normCh.length; // Usually 1
      }
    }

    int found = normalizedText.indexOf(normalizedQuery, currentNorm);
    if (found == -1) {
      return Text(
        text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.sp,
          height: 1.8,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontFamily: 'Amiri',
        ),
        textDirection: TextDirection.rtl,
      );
    }

    while (found != -1 && spans.length < 60) {
      final startOrig = mapIndexes[found] ?? currentOrig;
      final endOrig = mapIndexes[found + normalizedQuery.length] ?? (startOrig + normalizedQuery.length);

      if (startOrig > currentOrig) {
        spans.add(TextSpan(text: text.substring(currentOrig, startOrig)));
      }

      spans.add(
        TextSpan(
          text: text.substring(startOrig, endOrig.clamp(0, text.length)),
          style: TextStyle(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

      currentOrig = endOrig;
      currentNorm = found + normalizedQuery.length;
      found = normalizedText.indexOf(normalizedQuery, currentNorm);
    }

    if (currentOrig < text.length) {
      spans.add(TextSpan(text: text.substring(currentOrig)));
    }

    return RichText(
      textDirection: TextDirection.rtl,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          fontSize: 16.sp,
          height: 1.8,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontFamily: 'Amiri',
        ),
        children: spans,
      ),
    );
  }
}
