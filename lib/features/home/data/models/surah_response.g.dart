// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurahListResponse _$SurahListResponseFromJson(Map<String, dynamic> json) =>
    SurahListResponse(
      code: (json['code'] as num?)?.toInt(),
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Surah.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurahListResponseToJson(SurahListResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

Surah _$SurahFromJson(Map<String, dynamic> json) => Surah(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  englishName: json['englishName'] as String,
  englishNameTranslation: json['englishNameTranslation'] as String,
  numberOfAyahs: (json['numberOfAyahs'] as num).toInt(),
  revelationType: json['revelationType'] as String,
);

Map<String, dynamic> _$SurahToJson(Surah instance) => <String, dynamic>{
  'number': instance.number,
  'name': instance.name,
  'englishName': instance.englishName,
  'englishNameTranslation': instance.englishNameTranslation,
  'numberOfAyahs': instance.numberOfAyahs,
  'revelationType': instance.revelationType,
};
