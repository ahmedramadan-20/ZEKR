import 'package:json_annotation/json_annotation.dart';

import '../../../quran/data/models/surah_detail_response.dart';

part 'page_response.g.dart';

@JsonSerializable()
class PageResponse {
  final int code;
  final String status;
  final PageData data;

  PageResponse({required this.code, required this.status, required this.data});

  factory PageResponse.fromJson(Map<String, dynamic> json) =>
      _$PageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PageResponseToJson(this);
}

@JsonSerializable()
class PageData {
  final List<Ayah> ayahs;

  PageData({required this.ayahs});

  factory PageData.fromJson(Map<String, dynamic> json) =>
      _$PageDataFromJson(json);

  Map<String, dynamic> toJson() => _$PageDataToJson(this);
}
