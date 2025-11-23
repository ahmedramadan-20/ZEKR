import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/database_helper.dart';
import 'core/networking/dio_factory.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Dependency Injection
  await setupGetIt();

  // Register app lifecycle observer for cleanup
  WidgetsBinding.instance.addObserver(_AppLifecycleObserver());

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const QuranApp());
}

// App lifecycle observer to clean up resources
class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // App is closing - cleanup resources
      try {
        getIt<DatabaseHelper>().close();
      } catch (e) {
        // Database might not be initialized
      }

      try {
        DioFactory.dispose();
      } catch (e) {
        // Dio might not be initialized
      }
    }
  }
}
