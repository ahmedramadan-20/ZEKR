import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/surah_response.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = Loading;
  const factory HomeState.downloading({
    required int current,
    required int total,
  }) = Downloading;
  const factory HomeState.success({
    required List<Surah> surahs,
    @Default(false) bool isDownloadingInBackground,
    int? downloadProgress,
    int? totalToDownload,
  }) = Success;
  const factory HomeState.error(String message) = Error;
}
