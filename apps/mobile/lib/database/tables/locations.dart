import 'package:drift/drift.dart';

@TableIndex(name: 'locations_parent_idx', columns: {#parentLocationId})
@TableIndex(name: 'locations_name_idx', columns: {#name})
@DataClassName('LocationRow')
class Locations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentLocationId =>
      text().named('parent_location_id').nullable()();
  TextColumn get path => text().nullable()();
  TextColumn get nfcTagId => text().named('nfc_tag_id').nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get metadataJson =>
      text().named('metadata_json').withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};

  static const String _parentFk =
      'FOREIGN KEY(parent_location_id) REFERENCES locations(id) '
      'ON DELETE CASCADE';

  @override
  List<String> get customConstraints => [_parentFk];
}
