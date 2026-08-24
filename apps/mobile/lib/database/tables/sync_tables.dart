import 'package:drift/drift.dart';

/// Pending local mutations waiting to push.
@DataClassName('SyncOutboxRow')
class SyncOutbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text().named('entity_type')();
  TextColumn get entityId => text().named('entity_id')();
  /// upsert | delete
  TextColumn get op => text()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  /// JSON payload for upsert; null for delete.
  TextColumn get payloadJson => text().named('payload_json').nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

/// Local sync cursor and session (single row, id = 1).
@DataClassName('SyncStateRow')
class SyncState extends Table {
  IntColumn get id => integer()();
  TextColumn get cursor =>
      text().withDefault(const Constant('1970-01-01T00:00:00.000Z'))();
  TextColumn get sessionToken => text().named('session_token').nullable()();
  TextColumn get userId => text().named('user_id').nullable()();
  DateTimeColumn get lastSuccessAt =>
      dateTime().named('last_success_at').nullable()();
  BoolColumn get hasCompletedInitialSync => boolean()
      .named('has_completed_initial_sync')
      .withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
