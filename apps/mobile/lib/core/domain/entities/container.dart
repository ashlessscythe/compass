import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'container.freezed.dart';
part 'container.g.dart';

/// A physical or logical vessel that can hold assets.
@freezed
abstract class Container with _$Container {
  const factory Container({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? parentContainerId,
    String? locationId,
    String? nfcTagId,
    String? notes,
    @Default(Metadata.empty) Metadata metadata,
  }) = _Container;

  factory Container.fromJson(Map<String, dynamic> json) =>
      _$ContainerFromJson(json);
}
