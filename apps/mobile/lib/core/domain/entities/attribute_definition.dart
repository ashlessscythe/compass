import 'package:compass/core/domain/entities/attribute_value_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attribute_definition.freezed.dart';
part 'attribute_definition.g.dart';

/// Data-driven field on an asset type or module. Not a column on Asset.
@freezed
abstract class AttributeDefinition with _$AttributeDefinition {
  const factory AttributeDefinition({
    required String id,
    required String key,
    required AttributeValueType valueType,
    String? assetTypeId,
    String? moduleId,
    String? displayName,
    String? unit,
    String? vocabularyKey,
    @Default(false) bool isRequired,
  }) = _AttributeDefinition;

  factory AttributeDefinition.fromJson(Map<String, dynamic> json) =>
      _$AttributeDefinitionFromJson(json);
}
