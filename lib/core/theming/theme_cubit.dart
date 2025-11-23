import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/shared_pref_helper.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPrefHelper _sharedPrefHelper;

  ThemeCubit(this._sharedPrefHelper) : super(const ThemeState.light());

  /// Load saved theme from SharedPreferences
  Future<void> loadTheme() async {
    final isDark = _sharedPrefHelper.getIsDarkMode();
    emit(isDark ? const ThemeState.dark() : const ThemeState.light());
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newState = state.when(
      light: () => const ThemeState.dark(),
      dark: () => const ThemeState.light(),
    );
    await _sharedPrefHelper.setIsDarkMode(newState is DarkTheme);
    emit(newState);
  }

  /// Set theme explicitly
  Future<void> setTheme(bool isDark) async {
    await _sharedPrefHelper.setIsDarkMode(isDark);
    emit(isDark ? const ThemeState.dark() : const ThemeState.light());
  }

  /// Check if current theme is dark
  bool get isDark => state is DarkTheme;
}
