import 'package:freezed_annotation/freezed_annotation.dart';

part 'attribute_value.freezed.dart';
part 'attribute_value.g.dart';

/// One typed value for one attribute on one asset.
///
/// Enums and references store a canonical key (e.g. `material.gold.14k`),
/// not a display alias. Persistence is Metadata until attribute tables land.
@freezed
abstract class AttributeValue with _$AttributeValue {
  const factory AttributeValue({
    required String id,
    required String assetId,
    required String definitionId,
    /// JSON-compatible payload: string, number, bool, list, or map.
    required Object value,
    String? unit,
    String? controlledValueId,
  }) = _AttributeValue;

  factory AttributeValue.fromJson(Map<String, dynamic> json) =>
      _$AttributeValueFromJson(json);
}
