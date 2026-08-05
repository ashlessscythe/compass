// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Relationship _$RelationshipFromJson(Map<String, dynamic> json) =>
    _Relationship(
      id: json['id'] as String,
      sourceId: json['sourceId'] as String,
      targetId: json['targetId'] as String,
      kind: $enumDecode(_$RelationshipKindEnumMap, json['kind']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
      metadata: json['metadata'] == null
          ? Metadata.empty
          : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RelationshipToJson(_Relationship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceId': instance.sourceId,
      'targetId': instance.targetId,
      'kind': _$RelationshipKindEnumMap[instance.kind]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'notes': instance.notes,
      'metadata': instance.metadata,
    };

const _$RelationshipKindEnumMap = {
  RelationshipKind.contains: 'contains',
  RelationshipKind.relatedTo: 'relatedTo',
  RelationshipKind.partOf: 'partOf',
  RelationshipKind.attachedTo: 'attachedTo',
  RelationshipKind.custom: 'custom',
};
