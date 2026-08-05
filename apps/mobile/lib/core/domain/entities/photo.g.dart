// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Photo _$PhotoFromJson(Map<String, dynamic> json) => _Photo(
  id: json['id'] as String,
  entityId: json['entityId'] as String,
  entityKind: json['entityKind'] as String,
  storagePath: json['storagePath'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  caption: json['caption'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  metadata: json['metadata'] == null
      ? Metadata.empty
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PhotoToJson(_Photo instance) => <String, dynamic>{
  'id': instance.id,
  'entityId': instance.entityId,
  'entityKind': instance.entityKind,
  'storagePath': instance.storagePath,
  'createdAt': instance.createdAt.toIso8601String(),
  'caption': instance.caption,
  'sortOrder': instance.sortOrder,
  'metadata': instance.metadata,
};
