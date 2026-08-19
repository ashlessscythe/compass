// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribute_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttributeDefinition _$AttributeDefinitionFromJson(Map<String, dynamic> json) =>
    _AttributeDefinition(
      id: json['id'] as String,
      key: json['key'] as String,
      valueType: $enumDecode(_$AttributeValueTypeEnumMap, json['valueType']),
      assetTypeId: json['assetTypeId'] as String?,
      moduleId: json['moduleId'] as String?,
      displayName: json['displayName'] as String?,
      unit: json['unit'] as String?,
      vocabularyKey: json['vocabularyKey'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
    );

Map<String, dynamic> _$AttributeDefinitionToJson(
  _AttributeDefinition instance,
) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'valueType': _$AttributeValueTypeEnumMap[instance.valueType]!,
  'assetTypeId': instance.assetTypeId,
  'moduleId': instance.moduleId,
  'displayName': instance.displayName,
  'unit': instance.unit,
  'vocabularyKey': instance.vocabularyKey,
  'isRequired': instance.isRequired,
};

const _$AttributeValueTypeEnumMap = {
  AttributeValueType.string: 'string',
  AttributeValueType.integer: 'integer',
  AttributeValueType.decimal: 'decimal',
  AttributeValueType.boolean: 'boolean',
  AttributeValueType.date: 'date',
  AttributeValueType.dateRange: 'dateRange',
  AttributeValueType.enumeration: 'enum',
  AttributeValueType.multiSelect: 'multiSelect',
  AttributeValueType.reference: 'reference',
  AttributeValueType.measurement: 'measurement',
  AttributeValueType.currency: 'currency',
  AttributeValueType.url: 'url',
  AttributeValueType.identifier: 'identifier',
};
