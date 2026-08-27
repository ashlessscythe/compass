import 'package:drift/drift.dart';

@DataClassName('InstalledDomainPackRow')
class InstalledDomainPacks extends Table {
  TextColumn get packId => text().named('pack_id')();
  TextColumn get version => text()();
  TextColumn get moduleId => text().named('module_id')();
  DateTimeColumn get installedAt => dateTime().named('installed_at')();
  TextColumn get sourceUrl => text().named('source_url').nullable()();
  TextColumn get manifestJson => text().named('manifest_json').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {packId};
}

@DataClassName('PackAttributeDefinitionRow')
class PackAttributeDefinitions extends Table {
  TextColumn get id => text()();
  TextColumn get packId => text().named('pack_id')();
  TextColumn get key => text()();
  TextColumn get valueType => text().named('value_type')();
  TextColumn get assetTypeId => text().named('asset_type_id').nullable()();
  TextColumn get moduleId => text().named('module_id').nullable()();
  TextColumn get displayName => text().named('display_name').nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get vocabularyKey => text().named('vocabulary_key').nullable()();
  BoolColumn get isRequired =>
      boolean().named('is_required').withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PackControlledValueRow')
class PackControlledValues extends Table {
  TextColumn get id => text()();
  TextColumn get packId => text().named('pack_id')();
  TextColumn get vocabularyKey => text().named('vocabulary_key')();
  TextColumn get canonicalKey => text().named('canonical_key')();
  TextColumn get label => text()();
  TextColumn get parentId => text().named('parent_id').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
