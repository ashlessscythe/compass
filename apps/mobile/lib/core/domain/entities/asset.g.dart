// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Asset _$AssetFromJson(Map<String, dynamic> json) => _Asset(
  id: json['id'] as String,
  name: json['name'] as String,
  assetTypeId: json['assetTypeId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  containerId: json['containerId'] as String?,
  locationId: json['locationId'] as String?,
  notes: json['notes'] as String?,
  metadata: json['metadata'] == null
      ? Metadata.empty
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AssetToJson(_Asset instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'assetTypeId': instance.assetTypeId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'quantity': instance.quantity,
  'containerId': instance.containerId,
  'locationId': instance.locationId,
  'notes': instance.notes,
  'metadata': instance.metadata,
};
