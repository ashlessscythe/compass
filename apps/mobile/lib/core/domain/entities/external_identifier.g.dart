// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_identifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExternalIdentifier _$ExternalIdentifierFromJson(Map<String, dynamic> json) =>
    _ExternalIdentifier(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      entityKind: json['entityKind'] as String,
      source: json['source'] as String,
      externalId: json['externalId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ExternalIdentifierToJson(_ExternalIdentifier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'entityKind': instance.entityKind,
      'source': instance.source,
      'externalId': instance.externalId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
