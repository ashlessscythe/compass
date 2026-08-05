// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Movement _$MovementFromJson(Map<String, dynamic> json) => _Movement(
  id: json['id'] as String,
  subjectId: json['subjectId'] as String,
  subjectKind: $enumDecode(_$MovementSubjectKindEnumMap, json['subjectKind']),
  movedAt: DateTime.parse(json['movedAt'] as String),
  fromLocationId: json['fromLocationId'] as String?,
  toLocationId: json['toLocationId'] as String?,
  fromContainerId: json['fromContainerId'] as String?,
  toContainerId: json['toContainerId'] as String?,
  notes: json['notes'] as String?,
  metadata: json['metadata'] == null
      ? Metadata.empty
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MovementToJson(_Movement instance) => <String, dynamic>{
  'id': instance.id,
  'subjectId': instance.subjectId,
  'subjectKind': _$MovementSubjectKindEnumMap[instance.subjectKind]!,
  'movedAt': instance.movedAt.toIso8601String(),
  'fromLocationId': instance.fromLocationId,
  'toLocationId': instance.toLocationId,
  'fromContainerId': instance.fromContainerId,
  'toContainerId': instance.toContainerId,
  'notes': instance.notes,
  'metadata': instance.metadata,
};

const _$MovementSubjectKindEnumMap = {
  MovementSubjectKind.asset: 'asset',
  MovementSubjectKind.container: 'container',
};
