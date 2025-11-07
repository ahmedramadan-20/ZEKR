import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/dependency_injection.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Dependency Injection
  await setupGetIt();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const QuranApp());
}
