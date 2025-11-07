class ApiConstants {
  static const String baseUrl = 'http://api.alquran.cloud/v1/';
  static const String apiBaseUrl = baseUrl;

  // Endpoints
  static const String surahList = 'surah';
  static const String surahDetail = 'surah/{number}/{edition}';
  static const String page = 'page/{page}/{edition}';

  // Editions
  static const String defaultEdition = 'quran-uthmani';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
