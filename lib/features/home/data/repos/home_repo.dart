import 'package:quran/features/home/data/models/surah_response.dart';
import '../../../../core/helpers/database_helper.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_service.dart';

class HomeRepo {
  final ApiService _apiService;
  final DatabaseHelper _databaseHelper;
  final SharedPrefHelper _sharedPrefHelper;

  HomeRepo(this._apiService, this._databaseHelper, this._sharedPrefHelper);
  Future<List<Surah>> getSurahList() async {
    try {
      // First, check if we have data in local database
      final hasCachedData = await _databaseHelper.hasSurahs();
      print('Has cached data: $hasCachedData');

      if (hasCachedData) {
        // Return cached data
        final List<Surah> cachedSurahs = await _databaseHelper.getSurahs();
        print('Loaded ${cachedSurahs.length} surahs from cache');
        print('First surah type: ${cachedSurahs.first.runtimeType}');
        return cachedSurahs;
      }

      // If no cached data, fetch from API
      print('Fetching from API...');
      final response = await _apiService.getSurahList();
      final List<Surah> surahs = response.data ?? [];
      print('Fetched ${surahs.length} surahs from API');

      // Cache the data
      if (surahs.isNotEmpty) {
        await _databaseHelper.insertSurahs(surahs);
        print('Cached surahs to database');
      }

      return surahs;
    } catch (e) {
      print('Error in getSurahList: $e');
      print('Error type: ${e.runtimeType}');

      // If API fails, try to return cached data
      final hasCachedData = await _databaseHelper.hasSurahs();
      if (hasCachedData) {
        final List<Surah> cachedSurahs = await _databaseHelper.getSurahs();
        return cachedSurahs;
      }
      rethrow;
    }
  }

  Future<void> refreshSurahList() async {
    try {
      final response = await _apiService.getSurahList();
      final List<Surah> surahs = response.data ?? [];

      if (surahs.isNotEmpty) {
        await _databaseHelper.insertSurahs(surahs);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Download all Surahs
  Future downloadAllSurahs({
    required Function(int current, int total) onProgress,
  }) async {
    try {
      // Get list of all surahs
      final surahs = await getSurahList();
      final total = surahs.length;

      for (int i = 0; i < surahs.length; i++) {
        final surah = surahs[i];

        // Check if already downloaded
        final hasDetail = await _databaseHelper.hasSurahDetail(surah.number);

        if (!hasDetail) {
          try {
            // Download surah detail
            final response = await _apiService.getSurahDetail(
              surah.number,
              ApiConstants.defaultEdition,
            );

            // Save to database
            await _databaseHelper.insertSurahDetail(response.data);
          } catch (e) {
            print('Error downloading Surah ${surah.number}: $e');
            // Continue with next surah even if one fails
          }
        }

        // Update progress
        final progress = i + 1;
        await _sharedPrefHelper.setDownloadProgress(progress);
        onProgress(progress, total);

        // Small delay to avoid overwhelming the API
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Mark as completed
      await _sharedPrefHelper.setAllSurahsDownloaded(true);
    } catch (e) {
      rethrow;
    }
  }

  bool isAllSurahsDownloaded() {
    return _sharedPrefHelper.isAllSurahsDownloaded();
  }

  int getDownloadProgress() {
    return _sharedPrefHelper.getDownloadProgress();
  }
}
