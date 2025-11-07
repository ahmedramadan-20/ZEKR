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
    required int pageNumber,
    int? ayahNumber,
  }) async {
    await _sharedPrefHelper.saveLastReadSurah(surahNumber);
    await _sharedPrefHelper.saveLastReadPage(pageNumber);
    if (ayahNumber != null) {
      await _sharedPrefHelper.saveLastReadAyah(ayahNumber);
    }
  }

  // Get last read position
  Map getLastReadPosition() {
    return {
      'surah': _sharedPrefHelper.getLastReadSurah(),
      'page': _sharedPrefHelper.getLastReadPage(),
      'ayah': _sharedPrefHelper.getLastReadAyah(),
    };
  }
}
