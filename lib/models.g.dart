// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subdivision _$SubdivisionFromJson(Map<String, dynamic> json) {
  return Subdivision(
    json['id'] as String,
    json['name'] as String,
    json['local_name'] as String,
  );
}

Map<String, dynamic> _$SubdivisionToJson(Subdivision instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'local_name': instance.localName,
    };

City _$CityFromJson(Map<String, dynamic> json) {
  return City(
    json['id'] as String,
    json['name'] as String,
    json['local_name'] as String,
  );
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'local_name': instance.localName,
    };
