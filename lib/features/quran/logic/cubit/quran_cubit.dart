import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/surah_response.dart';
import '../../data/repos/quran_repo.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranRepo _quranRepo;
  StreamSubscription? _downloadSubscription;

  QuranCubit(this._quranRepo) : super(const QuranState.initial());

  @override
  Future<void> close() {
    _downloadSubscription?.cancel();
    return super.close();
  }

  Future getSurahList() async {
    emit(const QuranState.loading());
    try {
      final surahs = await _quranRepo.getSurahList();
      final needsBackgroundDownload = !_quranRepo.isAllSurahsDownloaded();
      
      // Get last read position
      final lastReadSurah = _quranRepo.getLastReadSurah();
      final lastReadPage = _quranRepo.getLastReadPage();

      emit(
        QuranState.success(
          surahs: surahs,
          isDownloadingInBackground: needsBackgroundDownload,
          downloadProgress: needsBackgroundDownload ? 0 : null,
          totalToDownload: needsBackgroundDownload ? 114 : null,
          lastReadSurah: lastReadSurah,
          lastReadPage: lastReadPage,
        ),
      );

      // Start background download if not completed
      if (needsBackgroundDownload) {
        _downloadInBackground(surahs);
      }
    } catch (e) {
      emit(QuranState.error('حدث خطأ أثناء تحميل السور: ${e.toString()}'));
    }
  }

  void _downloadInBackground(List<Surah> surahs) {
    // Use Stream for proper cancellation
    _downloadSubscription = _quranRepo
        .downloadAllSurahsStream(
          onProgress: (current, total) {
            // Check if cubit is still active before emitting
            if (!isClosed && state is Success) {
              final currentState = state as Success;
              emit(
                QuranState.success(
                  surahs: surahs,
                  isDownloadingInBackground: true,
                  downloadProgress: current,
                  totalToDownload: total,
                  lastReadSurah: currentState.lastReadSurah,
                  lastReadPage: currentState.lastReadPage,
                ),
              );
            }
          },
        )
        .listen(
          (_) {
            // Check if cubit is still active before emitting
            if (!isClosed && state is Success) {
              final currentState = state as Success;
              emit(
                QuranState.success(
                  surahs: surahs,
                  isDownloadingInBackground: false,
                  downloadProgress: null,
                  totalToDownload: null,
                  lastReadSurah: currentState.lastReadSurah,
                  lastReadPage: currentState.lastReadPage,
                ),
              );
            }
          },
          onError: (error) {
            // Background download failure shouldn't block UI
            if (!isClosed) {
              // Silently continue
            }
          },
          cancelOnError: false,
        );
  }
  
  // Add method to update last read position
  void updateLastReadPosition() {
    if (state is Success) {
      final currentState = state as Success;
      final lastReadSurah = _quranRepo.getLastReadSurah();
      final lastReadPage = _quranRepo.getLastReadPage();
      
      emit(
        QuranState.success(
          surahs: currentState.surahs,
          isDownloadingInBackground: currentState.isDownloadingInBackground,
          downloadProgress: currentState.downloadProgress,
          totalToDownload: currentState.totalToDownload,
          lastReadSurah: lastReadSurah,
          lastReadPage: lastReadPage,
        ),
      );
    }
  }

  Future refreshSurahList() async {
    try {
      await _quranRepo.refreshSurahList();
      await getSurahList();
    } catch (e) {
      // Silently fail on refresh
    }
  }

  Future downloadAllSurahs() async {
    emit(const QuranState.downloading(current: 0, total: 114));

    try {
      await _quranRepo.downloadAllSurahs(
        onProgress: (current, total) {
          emit(QuranState.downloading(current: current, total: total));
        },
      );

      // After download complete, load the list
      await getSurahList();
    } catch (e) {
      emit(QuranState.error('حدث خطأ أثناء التحميل: ${e.toString()}'));
    }
  }

  bool isAllSurahsDownloaded() {
    return _quranRepo.isAllSurahsDownloaded();
  }

  int getDownloadProgress() {
    return _quranRepo.getDownloadProgress();
  }
}
