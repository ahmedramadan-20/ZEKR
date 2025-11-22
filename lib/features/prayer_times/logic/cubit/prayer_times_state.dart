import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/prayer_times_model.dart';

part 'prayer_times_state.freezed.dart';

@freezed
class PrayerTimesState with _$PrayerTimesState {
  const factory PrayerTimesState.initial() = Initial;
  const factory PrayerTimesState.loading() = Loading;
  const factory PrayerTimesState.success(PrayerTimesModel prayerTimes) = Success;
  const factory PrayerTimesState.error(String message) = Error;
  const factory PrayerTimesState.permissionDenied() = PermissionDenied;
}
