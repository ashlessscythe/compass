import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship.freezed.dart';
part 'relationship.g.dart';

/// A typed link between two domain entities.
@freezed
abstract class Relationship with _$Relationship {
  const factory Relationship({
    required String id,
    required String sourceId,
    required String targetId,
    required RelationshipKind kind,
    required DateTime createdAt,
    String? notes,
    @Default(Metadata.empty) Metadata metadata,
  }) = _Relationship;

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);
}

enum RelationshipKind {
  contains,
  relatedTo,
  partOf,
  attachedTo,
  custom,
}
