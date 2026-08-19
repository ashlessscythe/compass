import 'package:drift/drift.dart';

@TableIndex(name: 'assets_container_idx', columns: {#containerId})
@TableIndex(name: 'assets_location_idx', columns: {#locationId})
@TableIndex(name: 'assets_name_idx', columns: {#name})
@DataClassName('AssetRow')
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get assetTypeId => text().named('asset_type_id')();
  TextColumn get containerId => text().named('container_id').nullable()();
  TextColumn get locationId => text().named('location_id').nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get metadataJson =>
      text().named('metadata_json').withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};

  static const String _typeFk =
      'FOREIGN KEY(asset_type_id) REFERENCES asset_types(id)';
  static const String _containerFk =
      'FOREIGN KEY(container_id) REFERENCES containers(id) ON DELETE SET NULL';
  static const String _locationFk =
      'FOREIGN KEY(location_id) REFERENCES locations(id) ON DELETE SET NULL';

  @override
  List<String> get customConstraints => [_typeFk, _containerFk, _locationFk];
}
