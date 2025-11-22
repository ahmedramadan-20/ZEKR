import 'package:json_annotation/json_annotation.dart';
import 'package:quran/features/quran/data/models/edition.dart';
import 'sajda.dart';
import 'sajda_converter.dart';

part 'surah_detail_response.g.dart';

@JsonSerializable()
class SurahDetailResponse {
  final int code;
  final String status;
  final SurahDetail data;
  final Edition? edition;

  SurahDetailResponse({
    required this.code,
    required this.status,
    required this.data,
    this.edition,
  });

  factory SurahDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$SurahDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SurahDetailResponseToJson(this);
}

@JsonSerializable()
class SurahDetail {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<Ayah> ayahs;

  SurahDetail({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) =>
      _$SurahDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SurahDetailToJson(this);
}

@JsonSerializable()
class Ayah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;

  @SajdaConverter()
  final Sajda sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) => _$AyahFromJson(json);

  Map<String, dynamic> toJson() => _$AyahToJson(this);
}
