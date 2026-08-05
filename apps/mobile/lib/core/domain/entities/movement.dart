import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement.freezed.dart';
part 'movement.g.dart';

/// Records a change of place for an asset or container.
@freezed
abstract class Movement with _$Movement {
  const factory Movement({
    required String id,
    required String subjectId,
    required MovementSubjectKind subjectKind,
    required DateTime movedAt,
    String? fromLocationId,
    String? toLocationId,
    String? fromContainerId,
    String? toContainerId,
    String? notes,
    @Default(Metadata.empty) Metadata metadata,
  }) = _Movement;

  factory Movement.fromJson(Map<String, dynamic> json) =>
      _$MovementFromJson(json);
}

enum MovementSubjectKind {
  asset,
  container,
}
