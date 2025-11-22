import 'package:quran/features/quran/data/models/surah_response.dart';
import '../../../../core/helpers/database_helper.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_service.dart';

class QuranRepo {
  final ApiService _apiService;
  final DatabaseHelper _databaseHelper;
  final SharedPrefHelper _sharedPrefHelper;

  QuranRepo(this._apiService, this._databaseHelper, this._sharedPrefHelper);

  Future<List<Surah>> getSurahList() async {
    try {
      // First, check if we have data in local database
      final hasCachedData = await _databaseHelper.hasSurahs();

      if (hasCachedData) {
        // Return cached data
        final List<Surah> cachedSurahs = await _databaseHelper.getSurahs();
        return cachedSurahs;
      }

      // If no cached data, fetch from API
      final response = await _apiService.getSurahList();
      final List<Surah> surahs = response.data ?? [];

      // Cache the data
      if (surahs.isNotEmpty) {
        await _databaseHelper.insertSurahs(surahs);
      }

      return surahs;
    } catch (e) {
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

  // Download all Surahs with progress reporting (Stream version for cancellation)
  Stream<void> downloadAllSurahsStream({
    required Function(int current, int total) onProgress,
  }) async* {
    await for (final _ in _downloadAllSurahsAsStream(onProgress: onProgress)) {
      yield null;
    }
  }

  // Keep old Future version for backward compatibility
  Future downloadAllSurahs({
    required Function(int current, int total) onProgress,
  }) async {
    await _downloadAllSurahs(onProgress: onProgress);
  }

  // Download all Surahs in background
  Future downloadAllSurahsInBackground() async {
    return _downloadAllSurahs(onProgress: (_, __) {});
  }

  // Internal download implementation (Future version)
  Future _downloadAllSurahs({
    required Function(int current, int total) onProgress,
  }) async {
    try {
      if (_sharedPrefHelper.isAllSurahsDownloaded()) {
        return;
      }

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

            // Allow UI to update after heavy database write - no extra delay needed
          } catch (e) {
            // Continue with next surah even if one fails
          }
        }

        // Update progress
        final progress = i + 1;
        await _sharedPrefHelper.setDownloadProgress(progress);
        onProgress(progress, total);

       // Small delay to prevent overwhelming the API
       await Future.delayed(const Duration(milliseconds: 20));

       // Removed periodic longer pause to keep downloads responsive
      }

      // Mark as completed
      await _sharedPrefHelper.setAllSurahsDownloaded(true);
    } catch (e) {
      // Don't rethrow in background download
    }
  }

  // Stream version for cancellable download
  Stream<void> _downloadAllSurahsAsStream({
    required Function(int current, int total) onProgress,
  }) async* {
    try {
      if (_sharedPrefHelper.isAllSurahsDownloaded()) {
        return;
      }

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

            // Save to database - this is the heavy operation
            await _databaseHelper.insertSurahDetail(response.data);

            // Yield immediately after database write to allow UI updates
            yield null;
          } catch (e) {
            // Continue with next surah even if one fails
          }
        }

        // Update progress
        final progress = i + 1;
        await _sharedPrefHelper.setDownloadProgress(progress);
        onProgress(progress, total);

       // Yield to event loop more frequently - every iteration
       yield null;

       // Small delay to prevent overwhelming the API
       await Future.delayed(const Duration(milliseconds: 20));

       // Removed periodic longer pause to keep downloads responsive
      }

      // Mark as completed
      await _sharedPrefHelper.setAllSurahsDownloaded(true);
    } catch (e) {
      // Don't rethrow in background download
    }
  }

  bool isAllSurahsDownloaded() {
    return _sharedPrefHelper.isAllSurahsDownloaded();
  }

  int getDownloadProgress() {
    return _sharedPrefHelper.getDownloadProgress();
  }

  int? getLastReadSurah() {
    return _sharedPrefHelper.getLastReadSurah();
  }

  int? getLastReadPage() {
    return _sharedPrefHelper.getLastReadPage();
  }
}
