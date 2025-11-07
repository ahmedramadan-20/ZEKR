import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final SharedPreferences _sharedPreferences;

  SharedPrefHelper(this._sharedPreferences);

  // Save last read position
  Future saveLastReadSurah(int surahNumber) async {
    await _sharedPreferences.setInt('last_read_surah', surahNumber);
  }

  Future saveLastReadPage(int pageNumber) async {
    await _sharedPreferences.setInt('last_read_page', pageNumber);
  }

  Future saveLastReadAyah(int ayahNumber) async {
    await _sharedPreferences.setInt('last_read_ayah', ayahNumber);
  }

  // Get last read position
  int? getLastReadSurah() {
    return _sharedPreferences.getInt('last_read_surah');
  }

  int? getLastReadPage() {
    return _sharedPreferences.getInt('last_read_page');
  }

  int? getLastReadAyah() {
    return _sharedPreferences.getInt('last_read_ayah');
  }

  // Download status
  Future setAllSurahsDownloaded(bool value) async {
    await _sharedPreferences.setBool('all_surahs_downloaded', value);
  }

  bool isAllSurahsDownloaded() {
    return _sharedPreferences.getBool('all_surahs_downloaded') ?? false;
  }

  Future setDownloadProgress(int progress) async {
    await _sharedPreferences.setInt('download_progress', progress);
  }

  int getDownloadProgress() {
    return _sharedPreferences.getInt('download_progress') ?? 0;
  }

  // Clear all data
  Future clearAll() async {
    await _sharedPreferences.clear();
  }
}
