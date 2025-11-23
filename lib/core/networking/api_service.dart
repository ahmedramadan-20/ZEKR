import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:quran/features/quran/data/models/surah_response.dart';
import 'package:quran/features/quran/data/models/surah_detail_response.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(ApiConstants.surahList)
  Future<SurahListResponse> getSurahList();

  @GET(ApiConstants.surahDetail)
  Future<SurahDetailResponse> getSurahDetail(
    @Path('number') int surahNumber,
    @Path('edition') String edition,
  );

  @GET(ApiConstants.page)
  Future<SurahDetailResponse> getPage(
    @Path('page') int pageNumber,
    @Path('edition') String edition,
  );
}
