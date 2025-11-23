import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/features/quran/logic/cubit/quran_cubit.dart';

import '../../features/home/ui/home_screen.dart';
import '../../features/quran/ui/quran_screen.dart';
import '../../features/surah_reader/logic/cubit/surah_reader_cubit.dart';
import '../../features/surah_reader/ui/surah_reader_screen.dart';
import '../../features/search/logic/cubit/search_cubit.dart';
import '../../features/search/ui/search_screen.dart';
import '../../features/bookmarks/logic/cubit/bookmarks_cubit.dart';
import '../../features/bookmarks/ui/bookmarks_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/prayer_times/logic/cubit/prayer_times_cubit.dart';
import '../../features/prayer_times/ui/prayer_times_screen.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    // this arguments to be passed in any screen like this (arguments as className)
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.quranScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<QuranCubit>()..getSurahList(),
            child: const QuranScreen(),
          ),
        );

      case Routes.surahReaderScreen:
        final args = arguments as SurahReaderArgs;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<SurahReaderCubit>()
                  ..loadSurah(args.surahNumber, initialPage: args.initialPage),
            child: SurahReaderScreen(
              surahNumber: args.surahNumber,
              surahName: args.surahName,
            ),
          ),
        );

      case Routes.searchScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SearchCubit>(),
            child: const SearchScreen(),
          ),
        );

      case Routes.bookmarksScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<BookmarksCubit>()..loadBookmarks(),
            child: const BookmarksScreen(),
          ),
        );

      case Routes.settingsScreen:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case Routes.prayerTimesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<PrayerTimesCubit>()..loadPrayerTimes(),
            child: const PrayerTimesScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No Route Found for ${settings.name}')),
          ),
        );
    }
  }
}

// Arguments Classes
class SurahReaderArgs {
  final int surahNumber;
  final String surahName;
  final int? initialPage;

  SurahReaderArgs({
    required this.surahNumber,
    required this.surahName,
    this.initialPage,
  });
}
