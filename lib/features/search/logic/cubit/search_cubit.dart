import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/search_repo.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo _searchRepo;
  final SharedPrefHelper _prefs;

  SearchCubit(this._searchRepo, this._prefs) : super(const SearchState.initial());

  Future<void> searchSurahs(String query) async {
    // If query is empty, return to initial state
    if (query.trim().isEmpty) {
      emit(const SearchState.initial());
      return;
    }

    // Check minimum length (2 characters for Ayah search)
    if (query.trim().length < 2) {
      emit(const SearchState.initial());
      return;
    }

    emit(const SearchState.loading());

    try {
      // Persist query in history (debounced upstream)
      await _prefs.addSearchHistory(query);
      // Search only Ayahs
      final results = await _searchRepo.searchAll(query);

      if (results.isEmpty) {
        emit(const SearchState.empty());
      } else {
        emit(SearchState.success(results));
      }
    } catch (e) {
      // Check if error is due to missing data
      if (e.toString().contains('No such table') ||
          e.toString().contains('database') ||
          e.toString().contains('null')) {
        emit(
          const SearchState.error(
            'لم يتم تحميل بيانات القرآن بعد.\nالرجاء الذهاب إلى شاشة القرآن أولاً لتحميل البيانات.',
          ),
        );
      } else {
        emit(SearchState.error('حدث خطأ أثناء البحث: ${e.toString()}'));
      }
    }
  }

  void clearSearch() {
    emit(const SearchState.initial());
  }
}
