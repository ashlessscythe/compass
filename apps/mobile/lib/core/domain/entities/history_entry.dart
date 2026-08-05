import 'package:compass/core/domain/entities/metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_entry.freezed.dart';
part 'history_entry.g.dart';

/// An immutable audit record for a domain change.
@freezed
abstract class HistoryEntry with _$HistoryEntry {
  const factory HistoryEntry({
    required String id,
    required String entityId,
    required String entityKind,
    required HistoryAction action,
    required DateTime occurredAt,
    String? summary,
    @Default(Metadata.empty) Metadata metadata,
  }) = _HistoryEntry;

  factory HistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$HistoryEntryFromJson(json);
}

enum HistoryAction {
  created,
  updated,
  deleted,
  moved,
  tagged,
  untagged,
}
