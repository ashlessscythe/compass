import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_identifier.freezed.dart';
part 'external_identifier.g.dart';

/// Maps a Compass entity to an id in an external taxonomy or dataset.
@freezed
abstract class ExternalIdentifier with _$ExternalIdentifier {
  const factory ExternalIdentifier({
    required String id,
    required String entityId,
    required String entityKind,
    required String source,
    required String externalId,
    required DateTime createdAt,
  }) = _ExternalIdentifier;

  factory ExternalIdentifier.fromJson(Map<String, dynamic> json) =>
      _$ExternalIdentifierFromJson(json);
}
