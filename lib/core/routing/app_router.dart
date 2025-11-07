import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/features/home/logic/cubit/home_cubit.dart';

import '../../features/home/ui/home_screen.dart';
import '../../features/surah_reader/logic/cubit/surah_reader_cubit.dart';
import '../../features/surah_reader/ui/surah_reader_screen.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    // this arguments to be passed in any screen like this (arguments as className)
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<HomeCubit>()..getSurahList(),
            child: const HomeScreen(),
          ),
        );

      case Routes.surahReaderScreen:
        final args = arguments as SurahReaderArgs;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<SurahReaderCubit>()..loadSurah(args.surahNumber),
            child: SurahReaderScreen(
              surahNumber: args.surahNumber,
              surahName: args.surahName,
            ),
          ),
        );

      case Routes.searchScreen:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Search Screen - Coming Soon')),
          ),
        );

      case Routes.settingsScreen:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Settings Screen - Coming Soon')),
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

  SurahReaderArgs({required this.surahNumber, required this.surahName});
}
