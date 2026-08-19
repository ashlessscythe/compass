import 'package:drift/drift.dart';

@TableIndex(name: 'containers_parent_idx', columns: {#parentContainerId})
@TableIndex(name: 'containers_location_idx', columns: {#locationId})
@TableIndex(name: 'containers_name_idx', columns: {#name})
@DataClassName('ContainerRow')
class Containers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentContainerId =>
      text().named('parent_container_id').nullable()();
  TextColumn get locationId => text().named('location_id').nullable()();
  TextColumn get nfcTagId => text().named('nfc_tag_id').nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get metadataJson =>
      text().named('metadata_json').withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};

  static const String _parentFk =
      'FOREIGN KEY(parent_container_id) REFERENCES containers(id) '
      'ON DELETE CASCADE';
  static const String _locationFk =
      'FOREIGN KEY(location_id) REFERENCES locations(id) ON DELETE CASCADE';

  @override
  List<String> get customConstraints => [_parentFk, _locationFk];
}
