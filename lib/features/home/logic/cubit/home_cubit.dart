import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(const HomeState.initial());

  Future getSurahList() async {
    emit(const HomeState.loading());
    try {
      final surahs = await _homeRepo.getSurahList();
      emit(HomeState.success(surahs));
    } catch (e) {
      emit(HomeState.error('حدث خطأ أثناء تحميل السور: ${e.toString()}'));
    }
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
