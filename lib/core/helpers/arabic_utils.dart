/// Utility functions for handling Arabic text
class ArabicUtils {
  /// Remove Arabic diacritics (tashkeel) from text
  /// This allows searching without worrying about diacritical marks
  static String removeDiacritics(String text) {
    if (text.isEmpty) return text;

    // Remove common Arabic diacritics (tashkeel) and Qur'anic annotation marks
    // Ranges include:
    // - 0610–061A: Arabic sign marks
    // - 064B–065F: Harakat, shadda, sukun, etc.
    // - 0670: Superscript Alef
    // - 06D6–06ED: Qur'anic annotation signs
    final diacriticsRegex = RegExp(r"[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]");

    // Remove tatweel
    final tatweelRegex = RegExp(r"[\u0640]");

    return text.replaceAll(diacriticsRegex, '').replaceAll(tatweelRegex, '');
  }

  /// Normalize Arabic text for search
  /// - Removes diacritics
  /// - Trims whitespace
  /// - Converts to lowercase (for mixed language support)
  static String normalizeForSearch(String text) {
    var t = removeDiacritics(text.trim());

    // Normalize common Arabic character variants to improve matching
    // Alif forms -> ا
    t = t
        .replaceAll(RegExp('[\u0622\u0623\u0625\u0671]'), 'ا')
        // Yeh variants (incl. alif maqsura) -> ي
        .replaceAll(RegExp('[\u0649\u064A]'), 'ي')
        // Waw with hamza -> و (optional, improves loose matching)
        .replaceAll('\u0624', 'و')
        // Yeh with hamza -> ي
        .replaceAll('\u0626', 'ي')
        // Teh marbuta -> ه (common search equivalence)
        .replaceAll('\u0629', 'ه');

    // Remove extraneous punctuation commonly in Arabic text
    t = t.replaceAll(RegExp('[\u061B\u061F\u060C]'), '');

    return t.toLowerCase();
  }

  /// Check if text contains query (diacritic-insensitive)
  static bool containsIgnoreDiacritics(String text, String query) {
    if (query.isEmpty) return false;
    if (text.isEmpty) return false;

    final normalizedText = normalizeForSearch(text);
    final normalizedQuery = normalizeForSearch(query);

    return normalizedText.contains(normalizedQuery);
  }

  /// Get all occurrences of query in text (diacritic-insensitive)
  /// Returns the start indices of each match
  static List<int> findAllOccurrences(String text, String query) {
    if (query.isEmpty || text.isEmpty) return [];

    final normalizedText = normalizeForSearch(text);
    final normalizedQuery = normalizeForSearch(query);
    final occurrences = <int>[];

    int index = normalizedText.indexOf(normalizedQuery);
    while (index != -1) {
      occurrences.add(index);
      index = normalizedText.indexOf(normalizedQuery, index + 1);
    }

    return occurrences;
  }

  /// Highlight query in text by wrapping matches
  /// Returns the original text with diacritics preserved
  static String highlightText(String text, String query) {
    if (query.isEmpty || text.isEmpty) return text;

    final normalizedText = normalizeForSearch(text);
    final normalizedQuery = normalizeForSearch(query);

    if (!normalizedText.contains(normalizedQuery)) {
      return text;
    }

    // This is a simplified version
    // For production, you'd want to preserve the exact positions
    return text;
  }
}
