import 'package:freezed_annotation/freezed_annotation.dart';

part 'metadata.freezed.dart';
part 'metadata.g.dart';

/// Extensible key-value bag for module-specific fields.
///
/// Core entities stay generic; vertical modules store specialized data here.
@freezed
abstract class Metadata with _$Metadata {
  const factory Metadata({
    @Default(<String, dynamic>{}) Map<String, dynamic> values,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  const Metadata._();

  static const Metadata empty = Metadata();

  dynamic operator [](String key) => values[key];

  bool get isEmpty => values.isEmpty;

  bool get isNotEmpty => values.isNotEmpty;
}
