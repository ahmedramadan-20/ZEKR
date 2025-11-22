import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/surah_response.dart';

part 'quran_state.freezed.dart';

@freezed
class QuranState with _$QuranState {
  const factory QuranState.initial() = _Initial;
  const factory QuranState.loading() = _Loading;
  const factory QuranState.downloading({
    required int current,
    required int total,
  }) = _Downloading;
  const factory QuranState.success({
    required List<Surah> surahs,
    required bool isDownloadingInBackground,
    int? downloadProgress,
    int? totalToDownload,
    int? lastReadSurah,
    int? lastReadPage,
  }) = Success;
  const factory QuranState.error(String message) = _Error;
}
