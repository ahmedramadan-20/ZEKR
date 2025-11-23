import 'package:json_annotation/json_annotation.dart';

part 'surah_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SurahListResponse {
  final int? code;
  final String? status;
  final List<Surah>? data;

  SurahListResponse({this.code, this.status, this.data});

  factory SurahListResponse.fromJson(Map<String, dynamic> json) =>
      _$SurahListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SurahListResponseToJson(this);
}

@JsonSerializable()
class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => _$SurahFromJson(json);

  Map<String, dynamic> toJson() => _$SurahToJson(this);
}
