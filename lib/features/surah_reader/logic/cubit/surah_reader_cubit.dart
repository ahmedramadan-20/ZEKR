import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../quran/data/models/surah_detail_response.dart';
import '../../data/repos/surah_reader_repo.dart';
import 'surah_reader_state.dart';

class SurahReaderCubit extends Cubit<SurahReaderState> {
  final SurahReaderRepo _surahReaderRepo;
  SurahDetail? _surahDetail;
  int _currentPage = 0;
  Set<int> _bookmarkedAyahs = {};
  final Set<int> _viewedPages = {}; // Track viewed pages

  SurahReaderCubit(this._surahReaderRepo)
    : super(const SurahReaderState.initial());

  Future loadSurah(int surahNumber, {int? initialPage}) async {
    emit(const SurahReaderState.loading());
    try {
      final response = await _surahReaderRepo.getSurahDetail(surahNumber);
      _surahDetail = response;

      // Load bookmarks for this surah
      _bookmarkedAyahs = await _surahReaderRepo.getBookmarkedAyahsForSurah(
        surahNumber,
      );

      // Determine which page to show
      final firstPageNumber = _surahDetail!.ayahs.first.page;
      final lastPageNumber = _surahDetail!.ayahs.last.page;

      // Use initialPage if provided and valid, otherwise use first page
      int targetPage = firstPageNumber;
      if (initialPage != null &&
          initialPage >= firstPageNumber &&
          initialPage <= lastPageNumber) {
        targetPage = initialPage;
      }

      _currentPage = targetPage;
      final currentPageAyahs = _getAyahsForPage(targetPage);

      emit(
        SurahReaderState.success(
          surahDetail: _surahDetail!,
          currentPage: targetPage,
          currentPageAyahs: currentPageAyahs,
          bookmarkedAyahs: Set<int>.from(_bookmarkedAyahs),
        ),
      );

      // Save last read position
      await _surahReaderRepo.saveLastReadPosition(
        surahNumber: surahNumber,
        surahName: _surahDetail!.name,
        pageNumber: targetPage,
      );
    } catch (e) {
      emit(SurahReaderState.error(e.toString()));
    }
  }

  void nextPage() {
    if (_surahDetail == null) return;

    final lastPageNumber = _surahDetail!.ayahs.last.page;
    if (_currentPage < lastPageNumber) {
      _currentPage++;

      // Track page view for stats
      if (!_viewedPages.contains(_currentPage)) {
        _viewedPages.add(_currentPage);
        _surahReaderRepo.incrementDailyPages();
      }

      final currentPageAyahs = _getAyahsForPage(_currentPage);

      // Track ayahs read
      _surahReaderRepo.incrementDailyAyahs(currentPageAyahs.length);

      emit(
        SurahReaderState.success(
          surahDetail: _surahDetail!,
          currentPage: _currentPage,
          currentPageAyahs: currentPageAyahs,
          bookmarkedAyahs: Set<int>.from(_bookmarkedAyahs),
        ),
      );

      // Save last read position
      _surahReaderRepo.saveLastReadPosition(
        surahNumber: _surahDetail!.number,
        surahName: _surahDetail!.name,
        pageNumber: _currentPage,
      );
    }
  }

  void previousPage() {
    if (_surahDetail == null) return;

    final firstPageNumber = _surahDetail!.ayahs.first.page;
    if (_currentPage > firstPageNumber) {
      _currentPage--;
      final currentPageAyahs = _getAyahsForPage(_currentPage);

      emit(
        SurahReaderState.success(
          surahDetail: _surahDetail!,
          currentPage: _currentPage,
          currentPageAyahs: currentPageAyahs,
          bookmarkedAyahs: Set<int>.from(_bookmarkedAyahs),
        ),
      );

      // Save last read position
      _surahReaderRepo.saveLastReadPosition(
        surahNumber: _surahDetail!.number,
        surahName: _surahDetail!.name,
        pageNumber: _currentPage,
      );
    }
  }

  Future<void> toggleBookmark(int ayahNumber) async {
    if (_surahDetail == null) return;
    if (state is! Success) return;

    final currentState = state as Success;
    final isCurrentlyBookmarked = _bookmarkedAyahs.contains(ayahNumber);

    // Update local state first
    if (isCurrentlyBookmarked) {
      _bookmarkedAyahs.remove(ayahNumber);
    } else {
      _bookmarkedAyahs.add(ayahNumber);
    }

    // Emit updated state immediately (optimistic update)
    emit(
      SurahReaderState.success(
        surahDetail: currentState.surahDetail,
        currentPage: currentState.currentPage,
        currentPageAyahs: currentState.currentPageAyahs,
        bookmarkedAyahs: Set<int>.from(_bookmarkedAyahs),
      ),
    );

    // Then perform the async database operation
    try {
      if (isCurrentlyBookmarked) {
        await _surahReaderRepo.removeBookmark(_surahDetail!.number, ayahNumber);
      } else {
        await _surahReaderRepo.addBookmark(
          surahNumber: _surahDetail!.number,
          surahName: _surahDetail!.name,
          ayahNumber: ayahNumber,
          pageNumber: _currentPage,
        );
      }
    } catch (e) {
      // If database operation fails, revert the change
      if (isCurrentlyBookmarked) {
        _bookmarkedAyahs.add(ayahNumber);
      } else {
        _bookmarkedAyahs.remove(ayahNumber);
      }
      
      // Emit reverted state
      emit(
        SurahReaderState.success(
          surahDetail: currentState.surahDetail,
          currentPage: currentState.currentPage,
          currentPageAyahs: currentState.currentPageAyahs,
          bookmarkedAyahs: Set<int>.from(_bookmarkedAyahs),
        ),
      );
    }
  }

  List _getAyahsForPage(int page) {
    if (_surahDetail == null) return [];
    return _surahDetail!.ayahs.where((ayah) => ayah.page == page).toList();
  }

  bool get canGoNext {
    if (_surahDetail == null) return false;
    return _currentPage < _surahDetail!.ayahs.last.page;
  }

  bool get canGoPrevious {
    if (_surahDetail == null) return false;
    return _currentPage > _surahDetail!.ayahs.first.page;
  }
}
