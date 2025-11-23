import '../../../../core/helpers/shared_pref_helper.dart';

class BookmarksRepo {
  final SharedPrefHelper _sharedPrefHelper;

  BookmarksRepo(this._sharedPrefHelper);

  /// Get all bookmarks sorted by timestamp (newest first)
  List<Map<String, dynamic>> getAllBookmarks() {
    return _sharedPrefHelper.getBookmarksList();
  }

  /// Remove a bookmark
  Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    await _sharedPrefHelper.removeBookmark(surahNumber, ayahNumber);
  }

  /// Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    await _sharedPrefHelper.clearAllBookmarks();
  }
}
