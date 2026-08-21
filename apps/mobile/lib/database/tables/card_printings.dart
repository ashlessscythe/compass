import 'package:drift/drift.dart';

@TableIndex(name: 'card_printings_set_collector_idx', columns: {
  #setCode,
  #collectorNumber,
})
@TableIndex(name: 'card_printings_name_idx', columns: {#nameNormalized})
@DataClassName('CardPrintingRow')
class CardPrintings extends Table {
  TextColumn get id => text()();
  TextColumn get oracleId => text().named('oracle_id').nullable()();
  TextColumn get name => text()();
  TextColumn get nameNormalized => text().named('name_normalized')();
  TextColumn get setCode => text().named('set_code')();
  TextColumn get collectorNumber => text().named('collector_number')();
  TextColumn get typeLine => text().named('type_line').nullable()();
  TextColumn get manaCost => text().named('mana_cost').nullable()();
  TextColumn get imageSmallUrl => text().named('image_small_url').nullable()();
  TextColumn get imageNormalUrl =>
      text().named('image_normal_url').nullable()();
  DateTimeColumn get fetchedAt => dateTime().named('fetched_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CatalogMetaRow')
class CatalogMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
