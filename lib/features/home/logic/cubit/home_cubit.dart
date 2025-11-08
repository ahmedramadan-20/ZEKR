import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/surah_response.dart';
import '../../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(const HomeState.initial());

  Future getSurahList() async {
    emit(const HomeState.loading());
    try {
      final surahs = await _homeRepo.getSurahList();
      final needsBackgroundDownload = !_homeRepo.isAllSurahsDownloaded();

      emit(
        HomeState.success(
          surahs: surahs,
          isDownloadingInBackground: needsBackgroundDownload,
          downloadProgress: needsBackgroundDownload ? 0 : null,
          totalToDownload: needsBackgroundDownload ? 114 : null,
        ),
      );

      // Start background download if not completed
      if (needsBackgroundDownload) {
        _downloadInBackground(surahs);
      }
    } catch (e) {
      emit(HomeState.error('حدث خطأ أثناء تحميل السور: ${e.toString()}'));
    }
  }

  void _downloadInBackground(List<Surah> surahs) {
    _homeRepo
        .downloadAllSurahs(
          onProgress: (current, total) {
            if (state is Success) {
              emit(
                HomeState.success(
                  surahs: surahs,
                  isDownloadingInBackground: true,
                  downloadProgress: current,
                  totalToDownload: total,
                ),
              );
            }
          },
        )
        .then((_) {
          if (state is Success) {
            emit(
              HomeState.success(
                surahs: surahs,
                isDownloadingInBackground: false,
                downloadProgress: null,
                totalToDownload: null,
              ),
            );
          }
        });
  }

  Future refreshSurahList() async {
    try {
      await _homeRepo.refreshSurahList();
      await getSurahList();
    } catch (e) {
      // Silently fail on refresh
    }
  }

  Future downloadAllSurahs() async {
    emit(const HomeState.downloading(current: 0, total: 114));

    try {
      await _homeRepo.downloadAllSurahs(
        onProgress: (current, total) {
          emit(HomeState.downloading(current: current, total: total));
        },
      );

      // After download complete, load the list
      await getSurahList();
    } catch (e) {
      emit(HomeState.error('حدث خطأ أثناء التحميل: ${e.toString()}'));
    }
  }

  bool isAllSurahsDownloaded() {
    return _homeRepo.isAllSurahsDownloaded();
  }

  int getDownloadProgress() {
    return _homeRepo.getDownloadProgress();
  }
}
