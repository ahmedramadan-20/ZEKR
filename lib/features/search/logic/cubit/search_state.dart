import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/search_result_model.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.success(List<SearchResult> results) = _Success;
  const factory SearchState.empty() = _Empty;
  const factory SearchState.error(String message) = _Error;
}
