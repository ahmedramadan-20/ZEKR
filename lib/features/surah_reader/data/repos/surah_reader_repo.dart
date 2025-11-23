import '../../../../core/helpers/database_helper.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_service.dart';

class SurahReaderRepo {
  final ApiService _apiService;
  final SharedPrefHelper _sharedPrefHelper;
  final DatabaseHelper _databaseHelper;

  SurahReaderRepo(
    this._apiService,
    this._sharedPrefHelper,
    this._databaseHelper,
  );

  Future getSurahDetail(int surahNumber) async {
    try {
      // First, check if we have cached data
      final cachedDetail = await _databaseHelper.getSurahDetail(surahNumber);

      if (cachedDetail != null) {
        // Return cached data
        return cachedDetail;
      }

      // If no cached data, fetch from API
      final response = await _apiService.getSurahDetail(
        surahNumber,
        ApiConstants.defaultEdition,
      );

      // Cache the data
      await _databaseHelper.insertSurahDetail(response.data);

      return response.data;
    } catch (e) {
      // If API fails, try to return cached data
      final cachedDetail = await _databaseHelper.getSurahDetail(surahNumber);
      if (cachedDetail != null) {
        return cachedDetail;
      }
      rethrow;
    }
  }

  Future getPageContent(int pageNumber) async {
    return await _apiService.getPage(pageNumber, ApiConstants.defaultEdition);
  }

  // Save last read position
  Future saveLastReadPosition({
    required int surahNumber,
    required String surahName,
    required int pageNumber,
    int? ayahNumber,
  }) async {
    await _sharedPrefHelper.saveLastReadSurah(surahNumber);
    await _sharedPrefHelper.saveLastReadSurahName(surahName);
    await _sharedPrefHelper.saveLastReadPage(pageNumber);
    if (ayahNumber != null) {
      await _sharedPrefHelper.saveLastReadAyah(ayahNumber);
    }
  }

  // Get last read position
  Map getLastReadPosition() {
    return {
      'surah': _sharedPrefHelper.getLastReadSurah(),
      'surahName': _sharedPrefHelper.getLastReadSurahName(),
      'page': _sharedPrefHelper.getLastReadPage(),
      'ayah': _sharedPrefHelper.getLastReadAyah(),
    };
  }

  // Bookmarks
  Future<void> addBookmark({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    required int pageNumber,
  }) async {
    await _sharedPrefHelper.addBookmark(
      surahNumber: surahNumber,
      surahName: surahName,
      ayahNumber: ayahNumber,
      pageNumber: pageNumber,
    );
  }

  Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    await _sharedPrefHelper.removeBookmark(surahNumber, ayahNumber);
  }

  Future<Set<int>> getBookmarkedAyahsForSurah(int surahNumber) async {
    final allBookmarks = _sharedPrefHelper.getBookmarksList();
    final ayahNumbers = allBookmarks
        .where((bookmark) => bookmark['surahNumber'] == surahNumber)
        .map((bookmark) => bookmark['ayahNumber'] as int)
        .toSet();
    return ayahNumbers;
  }

  bool isAyahBookmarked(int surahNumber, int ayahNumber) {
    return _sharedPrefHelper.isBookmarked(surahNumber, ayahNumber);
  }

  // Stats tracking
  Future<void> incrementDailyPages() async {
    await _sharedPrefHelper.incrementDailyPages();
  }

  Future<void> incrementDailyAyahs(int count) async {
    await _sharedPrefHelper.incrementDailyAyahs(count);
  }
}
