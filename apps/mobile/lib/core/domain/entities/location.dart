import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

/// A place in the world (or nested place) where containers and assets live.
@freezed
abstract class Location with _$Location {
  const factory Location({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? parentLocationId,
    String? path,
    String? nfcTagId,
    String? notes,
    @Default(Metadata.empty) Metadata metadata,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
