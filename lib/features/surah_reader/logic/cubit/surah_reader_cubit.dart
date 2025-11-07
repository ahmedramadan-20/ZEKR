import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/data/models/surah_detail_response.dart';
import '../../data/repos/surah_reader_repo.dart';
import 'surah_reader_state.dart';

class SurahReaderCubit extends Cubit<SurahReaderState> {
  final SurahReaderRepo _surahReaderRepo;
  SurahDetail? _surahDetail;
  int _currentPage = 0;

  SurahReaderCubit(this._surahReaderRepo)
    : super(const SurahReaderState.initial());

  Future loadSurah(int surahNumber) async {
    emit(const SurahReaderState.loading());
    try {
      final response = await _surahReaderRepo.getSurahDetail(surahNumber);
      _surahDetail = response;

      // Get first page ayahs
      final firstPageNumber = _surahDetail!.ayahs.first.page;
      _currentPage = firstPageNumber;

      final currentPageAyahs = _getAyahsForPage(firstPageNumber);

      emit(
        SurahReaderState.success(
          surahDetail: _surahDetail!,
          currentPage: firstPageNumber,
          currentPageAyahs: currentPageAyahs,
        ),
      );

      // Save last read position
      await _surahReaderRepo.saveLastReadPosition(
        surahNumber: surahNumber,
        pageNumber: firstPageNumber,
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
      final currentPageAyahs = _getAyahsForPage(_currentPage);

      emit(
        SurahReaderState.success(
          surahDetail: _surahDetail!,
          currentPage: _currentPage,
          currentPageAyahs: currentPageAyahs,
        ),
      );

      // Save last read position
      _surahReaderRepo.saveLastReadPosition(
        surahNumber: _surahDetail!.number,
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
        ),
      );

      // Save last read position
      _surahReaderRepo.saveLastReadPosition(
        surahNumber: _surahDetail!.number,
        pageNumber: _currentPage,
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
