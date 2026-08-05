import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo.freezed.dart';
part 'photo.g.dart';

/// A local or remote image associated with a domain entity.
@freezed
abstract class Photo with _$Photo {
  const factory Photo({
    required String id,
    required String entityId,
    required String entityKind,
    required String storagePath,
    required DateTime createdAt,
    String? caption,
    int? sortOrder,
    @Default(Metadata.empty) Metadata metadata,
  }) = _Photo;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}
