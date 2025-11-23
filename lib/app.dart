import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theming/app_theme.dart';
import 'core/theming/theme_cubit.dart';
import 'core/theming/theme_state.dart';

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  // Create AppRouter once as static to avoid recreating on every build
  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ThemeCubit>()..loadTheme(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'القرآن الكريم',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.when(
                  light: () => ThemeMode.light,
                  dark: () => ThemeMode.dark,
                ),

                // RTL Support
                locale: const Locale('ar', 'SA'),
                supportedLocales: const [
                  Locale('ar', 'SA'),
                  Locale('en', 'US'),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                initialRoute: Routes.homeScreen,
                onGenerateRoute: _appRouter.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
