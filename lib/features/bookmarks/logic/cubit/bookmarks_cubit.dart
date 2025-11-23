import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/bookmarks_repo.dart';
import 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarksRepo _bookmarksRepo;

  BookmarksCubit(this._bookmarksRepo) : super(const BookmarksState.initial());

  /// Load all bookmarks
  Future<void> loadBookmarks() async {
    try {
      final bookmarks = _bookmarksRepo.getAllBookmarks();

      if (bookmarks.isEmpty) {
        emit(const BookmarksState.empty());
      } else {
        emit(BookmarksState.success(bookmarks: bookmarks));
      }
    } catch (e) {
      emit(
        BookmarksState.error(
          'حدث خطأ أثناء تحميل الإشارات المرجعية: ${e.toString()}',
        ),
      );
    }
  }

  /// Remove a specific bookmark
  Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    try {
      await _bookmarksRepo.removeBookmark(surahNumber, ayahNumber);
      // Reload bookmarks to update UI
      loadBookmarks();
    } catch (e) {
      emit(BookmarksState.error(e.toString()));
    }
  }

  /// Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    try {
      await _bookmarksRepo.clearAllBookmarks();
      emit(const BookmarksState.empty());
    } catch (e) {
      emit(BookmarksState.error(e.toString()));
    }
  }
}
