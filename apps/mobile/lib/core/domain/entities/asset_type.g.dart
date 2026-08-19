// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetType _$AssetTypeFromJson(Map<String, dynamic> json) => _AssetType(
  id: json['id'] as String,
  name: json['name'] as String,
  moduleId: json['moduleId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  parentId: json['parentId'] as String?,
  description: json['description'] as String?,
  metadata: json['metadata'] == null
      ? Metadata.empty
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AssetTypeToJson(_AssetType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'moduleId': instance.moduleId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'parentId': instance.parentId,
      'description': instance.description,
      'metadata': instance.metadata,
    };
