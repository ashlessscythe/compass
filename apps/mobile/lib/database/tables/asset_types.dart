import 'package:drift/drift.dart';

@TableIndex(name: 'asset_types_module_idx', columns: {#moduleId})
@DataClassName('AssetTypeRow')
class AssetTypes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get moduleId => text().named('module_id')();
  TextColumn get description => text().nullable()();
  TextColumn get metadataJson =>
      text().named('metadata_json').withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
