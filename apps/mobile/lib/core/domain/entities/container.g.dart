// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Container _$ContainerFromJson(Map<String, dynamic> json) => _Container(
  id: json['id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  parentContainerId: json['parentContainerId'] as String?,
  locationId: json['locationId'] as String?,
  nfcTagId: json['nfcTagId'] as String?,
  notes: json['notes'] as String?,
  metadata: json['metadata'] == null
      ? Metadata.empty
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContainerToJson(_Container instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'parentContainerId': instance.parentContainerId,
      'locationId': instance.locationId,
      'nfcTagId': instance.nfcTagId,
      'notes': instance.notes,
      'metadata': instance.metadata,
    };
