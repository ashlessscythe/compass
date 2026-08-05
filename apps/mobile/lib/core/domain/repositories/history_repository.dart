import 'package:compass/core/domain/entities/history_entry.dart';

/// Persistence contract for [HistoryEntry] audit records.
abstract interface class HistoryRepository {
  Future<List<HistoryEntry>> getAll();

  Future<HistoryEntry?> getById(String id);

  Future<List<HistoryEntry>> getByEntityId(String entityId);

  Stream<List<HistoryEntry>> watchAll();

  Future<HistoryEntry> create(HistoryEntry entry);

  Future<void> delete(String id);
}
