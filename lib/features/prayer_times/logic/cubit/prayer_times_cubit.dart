import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/prayer_times_repo.dart';
import 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerTimesRepo _prayerTimesRepo;

  PrayerTimesCubit(this._prayerTimesRepo)
      : super(const PrayerTimesState.initial());

  /// Load prayer times
  Future<void> loadPrayerTimes() async {
    emit(const PrayerTimesState.loading());
    
    try {
      // Check permission first
      final hasPermission = await _prayerTimesRepo.hasLocationPermission();
      
      if (!hasPermission) {
        emit(const PrayerTimesState.permissionDenied());
        return;
      }

      // Get prayer times
      final prayerTimes = await _prayerTimesRepo.getPrayerTimes();
      emit(PrayerTimesState.success(prayerTimes));
    } catch (e) {
      emit(PrayerTimesState.error(e.toString()));
    }
  }

  /// Request location permission and reload
  Future<void> requestPermissionAndLoad() async {
    emit(const PrayerTimesState.loading());
    
    try {
      final granted = await _prayerTimesRepo.requestLocationPermission();
      
      if (granted) {
        await loadPrayerTimes();
      } else {
        emit(const PrayerTimesState.permissionDenied());
      }
    } catch (e) {
      emit(PrayerTimesState.error(e.toString()));
    }
  }

  /// Refresh prayer times
  Future<void> refresh() async {
    await loadPrayerTimes();
  }
}
