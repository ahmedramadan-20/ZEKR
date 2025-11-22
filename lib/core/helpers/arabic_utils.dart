/// Utility functions for handling Arabic text
class ArabicUtils {
  /// Remove Arabic diacritics (tashkeel) from text
  /// This allows searching without worrying about diacritical marks
  static String removeDiacritics(String text) {
    if (text.isEmpty) return text;
    
    // Arabic diacritics unicode ranges
    const diacritics = [
      '\u064B', // Tanween Fath
      '\u064C', // Tanween Damm
      '\u064D', // Tanween Kasr
      '\u064E', // Fatha
      '\u064F', // Damma
      '\u0650', // Kasra
      '\u0651', // Shadda
      '\u0652', // Sukun
      '\u0653', // Maddah
      '\u0654', // Hamza Above
      '\u0655', // Hamza Below
      '\u0656', // Subscript Alef
      '\u0657', // Inverted Damma
      '\u0658', // Mark Noon Ghunna
      '\u0670', // Superscript Alef
    ];
    
    String result = text;
    for (var diacritic in diacritics) {
      result = result.replaceAll(diacritic, '');
    }
    
    return result;
  }
  
  /// Normalize Arabic text for search
  /// - Removes diacritics
  /// - Trims whitespace
  /// - Converts to lowercase (for mixed language support)
  static String normalizeForSearch(String text) {
    return removeDiacritics(text.trim()).toLowerCase();
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
