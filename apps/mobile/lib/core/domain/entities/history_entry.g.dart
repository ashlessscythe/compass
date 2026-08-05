// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryEntry _$HistoryEntryFromJson(Map<String, dynamic> json) =>
    _HistoryEntry(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      entityKind: json['entityKind'] as String,
      action: $enumDecode(_$HistoryActionEnumMap, json['action']),
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      summary: json['summary'] as String?,
      metadata: json['metadata'] == null
          ? Metadata.empty
          : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HistoryEntryToJson(_HistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'entityKind': instance.entityKind,
      'action': _$HistoryActionEnumMap[instance.action]!,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'summary': instance.summary,
      'metadata': instance.metadata,
    };

const _$HistoryActionEnumMap = {
  HistoryAction.created: 'created',
  HistoryAction.updated: 'updated',
  HistoryAction.deleted: 'deleted',
  HistoryAction.moved: 'moved',
  HistoryAction.tagged: 'tagged',
  HistoryAction.untagged: 'untagged',
};
