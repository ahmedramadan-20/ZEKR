import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/surah_detail_response.dart';

part 'surah_reader_state.freezed.dart';

@freezed
class SurahReaderState with _$SurahReaderState {
  const factory SurahReaderState.initial() = _Initial;
  const factory SurahReaderState.loading() = Loading;
  const factory SurahReaderState.success({
    required SurahDetail surahDetail,
    required int currentPage,
    required List currentPageAyahs,
  }) = Success;
  const factory SurahReaderState.error(String message) = Error;
}
