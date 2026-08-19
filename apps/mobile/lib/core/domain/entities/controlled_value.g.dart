// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controlled_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ControlledValue _$ControlledValueFromJson(Map<String, dynamic> json) =>
    _ControlledValue(
      id: json['id'] as String,
      vocabularyKey: json['vocabularyKey'] as String,
      canonicalKey: json['canonicalKey'] as String,
      label: json['label'] as String,
      parentId: json['parentId'] as String?,
      metadata: json['metadata'] == null
          ? Metadata.empty
          : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ControlledValueToJson(_ControlledValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vocabularyKey': instance.vocabularyKey,
      'canonicalKey': instance.canonicalKey,
      'label': instance.label,
      'parentId': instance.parentId,
      'metadata': instance.metadata,
    };
