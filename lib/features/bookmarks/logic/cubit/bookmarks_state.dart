import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmarks_state.freezed.dart';

@freezed
class BookmarksState with _$BookmarksState {
  const factory BookmarksState.initial() = _Initial;
  const factory BookmarksState.loading() = _Loading;
  const factory BookmarksState.success({
    required List<Map<String, dynamic>> bookmarks,
  }) = _Success;
  const factory BookmarksState.empty() = _Empty;
  const factory BookmarksState.error(String message) = _Error;
}
