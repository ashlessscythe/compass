import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

/// A generic tracked item.
///
/// Vertical fields (set, foil, material, carat, …) do not belong here.
/// Store them as attribute values, or in [metadata] until tables persist.
@freezed
abstract class Asset with _$Asset {
  const factory Asset({
    required String id,
    required String name,
    required String assetTypeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(1) int quantity,
    String? containerId,
    String? locationId,
    String? notes,
    @Default(Metadata.empty) Metadata metadata,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
