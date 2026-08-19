import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_type.freezed.dart';
part 'asset_type.g.dart';

/// Classification of an Asset. Types may nest via [parentId].
///
/// Domain fields live on attribute schemas, not on this type's columns.
@freezed
abstract class AssetType with _$AssetType {
  const factory AssetType({
    required String id,
    required String name,
    required String moduleId,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? parentId,
    String? description,
    @Default(Metadata.empty) Metadata metadata,
  }) = _AssetType;

  factory AssetType.fromJson(Map<String, dynamic> json) =>
      _$AssetTypeFromJson(json);
}
