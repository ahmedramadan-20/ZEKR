import 'dart:convert';
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

  Future saveLastReadSurahName(String surahName) async {
    await _sharedPreferences.setString('last_read_surah_name', surahName);
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

  String? getLastReadSurahName() {
    return _sharedPreferences.getString('last_read_surah_name');
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

  // Bookmarks
  Future<void> addBookmark({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    required int pageNumber,
  }) async {
    final bookmarks = getBookmarks();
    final bookmarkKey = '${surahNumber}_$ayahNumber';

    bookmarks[bookmarkKey] = {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'pageNumber': pageNumber,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    await _saveBookmarks(bookmarks);
  }

  Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    final bookmarks = getBookmarks();
    final bookmarkKey = '${surahNumber}_$ayahNumber';
    bookmarks.remove(bookmarkKey);
    await _saveBookmarks(bookmarks);
  }

  bool isBookmarked(int surahNumber, int ayahNumber) {
    final bookmarks = getBookmarks();
    final bookmarkKey = '${surahNumber}_$ayahNumber';
    return bookmarks.containsKey(bookmarkKey);
  }

  Map<String, dynamic> getBookmarks() {
    // Prefer JSON storage if present
    final jsonString = _sharedPreferences.getString('bookmarks_json');
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        // Ensure values are maps
        return decoded.map(
          (key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)),
        );
      } catch (_) {
        // Fall back to legacy if JSON corrupted
      }
    }

    // Legacy format fallback + migrate
    final keys = _sharedPreferences.getStringList('bookmark_keys') ?? [];
    final bookmarks = <String, dynamic>{};

    for (var key in keys) {
      final surahNumber = _sharedPreferences.getInt('bookmark_${key}_surah');
      final surahName = _sharedPreferences.getString('bookmark_${key}_name');
      final ayahNumber = _sharedPreferences.getInt('bookmark_${key}_ayah');
      final pageNumber = _sharedPreferences.getInt('bookmark_${key}_page');
      final timestamp = _sharedPreferences.getInt('bookmark_${key}_time');

      if (surahNumber != null && surahName != null && ayahNumber != null) {
        bookmarks[key] = {
          'surahNumber': surahNumber,
          'surahName': surahName,
          'ayahNumber': ayahNumber,
          'pageNumber': pageNumber ?? 1,
          'timestamp': timestamp ?? 0,
        };
      }
    }

    // Migrate to JSON format for atomicity
    _sharedPreferences.setString('bookmarks_json', jsonEncode(bookmarks));

    return bookmarks;
  }

  Future<void> _saveBookmarks(Map<String, dynamic> bookmarks) async {
    // Atomic single write using JSON
    await _sharedPreferences.setString('bookmarks_json', jsonEncode(bookmarks));
  }

  List<Map<String, dynamic>> getBookmarksList() {
    final map = getBookmarks();
    final list = map.values.map((e) => Map<String, dynamic>.from(e)).toList();

    // Sort by timestamp (newest first)
    list.sort(
      (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int),
    );
    return list;
  }

  // Daily Stats Tracking
  Future incrementPagesReadToday() async {
    final todayKey = _getTodayDateKey();
    final currentCount = _sharedPreferences.getInt('pages_read_$todayKey') ?? 0;
    await _sharedPreferences.setInt('pages_read_$todayKey', currentCount + 1);
  }

  int getPagesReadToday() {
    final todayKey = _getTodayDateKey();
    return _sharedPreferences.getInt('pages_read_$todayKey') ?? 0;
  }

  Future incrementAyahsMemorizedToday() async {
    final todayKey = _getTodayDateKey();
    final currentCount =
        _sharedPreferences.getInt('ayahs_memorized_$todayKey') ?? 0;
    await _sharedPreferences.setInt(
      'ayahs_memorized_$todayKey',
      currentCount + 1,
    );
  }

  int getAyahsMemorizedToday() {
    final todayKey = _getTodayDateKey();
    return _sharedPreferences.getInt('ayahs_memorized_$todayKey') ?? 0;
  }

  String _getTodayDateKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}';
  }

  // Settings
  String getFontSize() {
    return _sharedPreferences.getString('font_size') ?? 'medium';
  }

  Future<void> setFontSize(String size) async {
    await _sharedPreferences.setString('font_size', size);
  }

  bool getAutoSavePosition() {
    return _sharedPreferences.getBool('auto_save_position') ?? true;
  }

  Future<void> setAutoSavePosition(bool value) async {
    await _sharedPreferences.setBool('auto_save_position', value);
  }

  // Reading Stats
  int getDailyPagesRead() {
    final lastReset = _sharedPreferences.getInt('stats_last_reset') ?? 0;
    final today =
        DateTime.now().millisecondsSinceEpoch ~/ 86400000; // Days since epoch

    if (lastReset != today) {
      // Reset stats for new day
      _sharedPreferences.setInt('stats_daily_pages', 0);
      _sharedPreferences.setInt('stats_daily_ayahs', 0);
      _sharedPreferences.setInt('stats_last_reset', today);
      return 0;
    }

    return _sharedPreferences.getInt('stats_daily_pages') ?? 0;
  }

  Future<void> incrementDailyPages() async {
    final current = getDailyPagesRead();
    await _sharedPreferences.setInt('stats_daily_pages', current + 1);
  }

  int getDailyAyahsRead() {
    getDailyPagesRead(); // Ensure stats are reset if needed
    return _sharedPreferences.getInt('stats_daily_ayahs') ?? 0;
  }

  Future<void> incrementDailyAyahs(int count) async {
    final current = getDailyAyahsRead();
    await _sharedPreferences.setInt('stats_daily_ayahs', current + count);
  }

  // Prayer Times Settings
  String getPrayerCalculationMethod() {
    return _sharedPreferences.getString('prayer_calculation_method') ??
        'MuslimWorldLeague';
  }

  Future<void> setPrayerCalculationMethod(String method) async {
    await _sharedPreferences.setString('prayer_calculation_method', method);
  }

  void clearDailyStats() {
    _sharedPreferences.setInt('stats_daily_pages', 0);
    _sharedPreferences.setInt('stats_daily_ayahs', 0);
  }

  // Clear all data
  Future clearAll() async {
    await _sharedPreferences.clear();
  }

  // Clear all bookmarks (JSON + legacy cleanup)
  Future<void> clearAllBookmarks() async {
    final futures = <Future>[];
    futures.add(_sharedPreferences.remove('bookmarks_json'));

    // Legacy cleanup
    final keys = _sharedPreferences.getStringList('bookmark_keys') ?? [];
    futures.add(_sharedPreferences.setStringList('bookmark_keys', []));
    for (var key in keys) {
      futures.add(_sharedPreferences.remove('bookmark_${key}_surah'));
      futures.add(_sharedPreferences.remove('bookmark_${key}_name'));
      futures.add(_sharedPreferences.remove('bookmark_${key}_ayah'));
      futures.add(_sharedPreferences.remove('bookmark_${key}_page'));
      futures.add(_sharedPreferences.remove('bookmark_${key}_time'));
    }

    await Future.wait(futures);
  }

  // Theme Settings
  bool getIsDarkMode() {
    return _sharedPreferences.getBool('is_dark_mode') ?? false;
  }

  Future<void> setIsDarkMode(bool value) async {
    await _sharedPreferences.setBool('is_dark_mode', value);
  }
}
