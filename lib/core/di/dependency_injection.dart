import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/quran/data/repos/quran_repo.dart';
import '../../features/quran/logic/cubit/quran_cubit.dart';
import '../../features/surah_reader/data/repos/surah_reader_repo.dart';
import '../../features/surah_reader/logic/cubit/surah_reader_cubit.dart';
import '../../features/search/data/repos/search_repo.dart';
import '../../features/search/logic/cubit/search_cubit.dart';
import '../../features/bookmarks/data/repos/bookmarks_repo.dart';
import '../../features/bookmarks/logic/cubit/bookmarks_cubit.dart';
import '../../features/prayer_times/data/repos/prayer_times_repo.dart';
import '../../features/prayer_times/logic/cubit/prayer_times_cubit.dart';
import '../helpers/database_helper.dart';
import '../helpers/shared_pref_helper.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import '../theming/theme_cubit.dart';
import '../services/notification_service.dart';

final getIt = GetIt.instance;

Future setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton(() => ApiService(dio));

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => SharedPrefHelper(getIt()));

  // Database
  getIt.registerLazySingleton(() => DatabaseHelper.instance);

  // Quran Feature
  getIt.registerLazySingleton(() => QuranRepo(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => QuranCubit(getIt()));

  // Surah Reader Feature
  getIt.registerLazySingleton(() => SurahReaderRepo(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => SurahReaderCubit(getIt()));

  // Search Feature
  getIt.registerLazySingleton(() => SearchRepo(getIt()));
  getIt.registerFactory(() => SearchCubit(getIt(), getIt()));

  // Bookmarks Feature
  getIt.registerLazySingleton(() => BookmarksRepo(getIt()));
  getIt.registerFactory(() => BookmarksCubit(getIt()));

  // Prayer Times Feature
  getIt.registerLazySingleton(() => PrayerTimesRepo(getIt()));
  getIt.registerFactory(() => PrayerTimesCubit(getIt(), getIt()));

  // Theme
  getIt.registerLazySingleton(() => ThemeCubit(getIt()));

  // Notifications
  getIt.registerLazySingleton(() => NotificationService());
}
