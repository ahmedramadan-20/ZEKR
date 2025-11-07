import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/data/repos/home_repo.dart';
import '../../features/home/logic/cubit/home_cubit.dart';
import '../../features/surah_reader/data/repos/surah_reader_repo.dart';
import '../../features/surah_reader/logic/cubit/surah_reader_cubit.dart';
import '../helpers/database_helper.dart';
import '../helpers/shared_pref_helper.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';

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

  // Home Feature
  getIt.registerLazySingleton(() => HomeRepo(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));

  // Surah Reader Feature
  getIt.registerLazySingleton(() => SurahReaderRepo(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => SurahReaderCubit(getIt()));
}
