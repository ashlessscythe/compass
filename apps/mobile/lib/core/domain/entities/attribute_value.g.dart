// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribute_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttributeValue _$AttributeValueFromJson(Map<String, dynamic> json) =>
    _AttributeValue(
      id: json['id'] as String,
      assetId: json['assetId'] as String,
      definitionId: json['definitionId'] as String,
      value: json['value'] as Object,
      unit: json['unit'] as String?,
      controlledValueId: json['controlledValueId'] as String?,
    );

Map<String, dynamic> _$AttributeValueToJson(_AttributeValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetId': instance.assetId,
      'definitionId': instance.definitionId,
      'value': instance.value,
      'unit': instance.unit,
      'controlledValueId': instance.controlledValueId,
    };
