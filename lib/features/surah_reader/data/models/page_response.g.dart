// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageResponse _$PageResponseFromJson(Map<String, dynamic> json) => PageResponse(
  code: (json['code'] as num).toInt(),
  status: json['status'] as String,
  data: PageData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PageResponseToJson(PageResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data,
    };

PageData _$PageDataFromJson(Map<String, dynamic> json) => PageData(
  ayahs: (json['ayahs'] as List<dynamic>)
      .map((e) => Ayah.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PageDataToJson(PageData instance) => <String, dynamic>{
  'ayahs': instance.ayahs,
};
