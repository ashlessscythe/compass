// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  id: json['id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  parentLocationId: json['parentLocationId'] as String?,
  path: json['path'] as String?,
  nfcTagId: json['nfcTagId'] as String?,
  notes: json['notes'] as String?,
  metadata: json['metadata'] == null
      ? Metadata.empty
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'parentLocationId': instance.parentLocationId,
  'path': instance.path,
  'nfcTagId': instance.nfcTagId,
  'notes': instance.notes,
  'metadata': instance.metadata,
};
