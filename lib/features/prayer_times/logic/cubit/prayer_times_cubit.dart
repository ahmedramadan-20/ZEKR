import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/prayer_times_repo.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/models/prayer_times_model.dart';
import 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerTimesRepo _prayerTimesRepo;
  final NotificationService _notificationService;

  PrayerTimesCubit(this._prayerTimesRepo, this._notificationService)
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

      // Schedule notifications
      await _scheduleNotifications(prayerTimes);

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

  Future<void> _scheduleNotifications(PrayerTimesModel prayerTimes) async {
    try {
      // Request permissions if not granted (or just ensure initialized)
      await _notificationService.init();
      await _notificationService.requestPermissions();

      await _notificationService.cancelAllNotifications();

      final prayers = prayerTimes.getAllPrayers();
      for (var i = 0; i < prayers.length; i++) {
        final prayer = prayers[i];
        // Only schedule if time is in the future
        if (prayer.time.isAfter(DateTime.now())) {
          await _notificationService.schedulePrayerNotification(
            id: i, // Use index as ID (0-5)
            title: 'حان وقت الصلاة',
            body: 'حان الآن موعد صلاة ${prayer.name}',
            scheduledTime: prayer.time,
          );
        }
      }
    } catch (e) {
      // Ignore notification errors to not block the UI
      print('Error scheduling notifications: $e');
    }
  }
}
