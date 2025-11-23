import 'package:quran/features/quran/data/models/surah_detail_response.dart';

import '../../../../core/helpers/database_helper.dart';
import '../../../../core/helpers/arabic_utils.dart';
import '../../../quran/data/models/surah_response.dart';
import '../models/search_result_model.dart';

class SearchRepo {
  final DatabaseHelper _databaseHelper;

  SearchRepo(this._databaseHelper);

  // Search only Surahs
  Future<List<SearchResult>> searchSurahs(String query) async {
    try {
      final allSurahs = await _databaseHelper.getSurahs();

      if (query.trim().isEmpty) {
        return [];
      }

      final lowerQuery = query.toLowerCase().trim();

      final filteredSurahs = allSurahs.where((surah) {
        // Search by surah number
        if (surah.number.toString() == lowerQuery) return true;

        // Search by Arabic name (ignore diacritics)
        if (ArabicUtils.containsIgnoreDiacritics(surah.name, query.trim())) {
          return true;
        }

        // Search by English name
        if (surah.englishName.toLowerCase().contains(lowerQuery)) return true;

        // Search by English translation
        if (surah.englishNameTranslation.toLowerCase().contains(lowerQuery)) {
          return true;
        }

        return false;
      }).toList();

      return filteredSurahs
          .map(
            (surah) => SearchResult(type: SearchResultType.surah, surah: surah),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Search only Ayahs (minimum 2 characters, max 100 results)
  Future<List<SearchResult>> searchAyahs(String query) async {
    try {
      if (query.trim().length < 2) {
        return [];
      }

      final ayahResults = await _databaseHelper.searchAyahs(query.trim());
      final searchResults = <SearchResult>[];

      // Get all surahs for reference
      final allSurahs = await _databaseHelper.getSurahs();

      for (var result in ayahResults) {
        if (searchResults.length >= 100) break; // Limit to 100 results

        final surahDetail = result['surahDetail'] as SurahDetail;
        final ayah = result['ayah'] as Ayah;

        // Find matching surah from list
        final surah = allSurahs.firstWhere(
          (s) => s.number == surahDetail.number,
          orElse: () => Surah(
            number: surahDetail.number,
            name: surahDetail.name,
            englishName: surahDetail.englishName,
            englishNameTranslation: surahDetail.englishNameTranslation,
            numberOfAyahs: surahDetail.numberOfAyahs,
            revelationType: surahDetail.revelationType,
          ),
        );

        searchResults.add(
          SearchResult(type: SearchResultType.ayah, surah: surah, ayah: ayah),
        );
      }

      return searchResults;
    } catch (e) {
      rethrow;
    }
  }

  // Search only Ayahs (removed Surah search since Surahs are already in the list)
  Future<List<SearchResult>> searchAll(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      // Only search Ayahs
      final ayahResults = await searchAyahs(query);
      return ayahResults;
    } catch (e) {
      rethrow;
    }
  }
}
