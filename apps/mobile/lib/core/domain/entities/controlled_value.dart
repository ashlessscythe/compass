import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'controlled_value.freezed.dart';
part 'controlled_value.g.dart';

/// Canonical term in a vocabulary.
/// Display labels may vary; [canonicalKey] does not.
@freezed
abstract class ControlledValue with _$ControlledValue {
  const factory ControlledValue({
    required String id,
    required String vocabularyKey,
    /// Stable id such as `material.gold.14k`.
    required String canonicalKey,
    required String label,
    String? parentId,
    @Default(Metadata.empty) Metadata metadata,
  }) = _ControlledValue;

  factory ControlledValue.fromJson(Map<String, dynamic> json) =>
      _$ControlledValueFromJson(json);
}
