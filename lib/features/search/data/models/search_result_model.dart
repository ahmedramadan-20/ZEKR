import '../../../quran/data/models/surah_detail_response.dart';
import '../../../quran/data/models/surah_response.dart';

enum SearchResultType { surah, ayah }

class SearchResult {
  final SearchResultType type;
  final Surah surah;
  final Ayah? ayah;

  SearchResult({required this.type, required this.surah, this.ayah});

  // Helper method to get display title
  String get displayTitle {
    if (type == SearchResultType.surah) {
      return surah.englishName;
    } else {
      return '${surah.name} - آية ${ayah!.numberInSurah}';
    }
  }

  // Helper method to get subtitle
  String get displaySubtitle {
    if (type == SearchResultType.surah) {
      return surah.englishNameTranslation;
    } else {
      return ayah!.text;
    }
  }
}
