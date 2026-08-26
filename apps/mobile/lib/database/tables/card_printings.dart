import 'package:drift/drift.dart';

@TableIndex(name: 'card_printings_set_collector_idx', columns: {
  #setCode,
  #collectorNumber,
})
@TableIndex(name: 'card_printings_name_idx', columns: {#nameNormalized})
@TableIndex(name: 'card_printings_oracle_id_idx', columns: {#oracleId})
@DataClassName('CardPrintingRow')
class CardPrintings extends Table {
  TextColumn get id => text()();
  TextColumn get oracleId => text().named('oracle_id').nullable()();
  TextColumn get name => text()();
  TextColumn get nameNormalized => text().named('name_normalized')();
  TextColumn get setCode => text().named('set_code')();
  TextColumn get collectorNumber => text().named('collector_number')();
  TextColumn get layout => text().nullable()();
  TextColumn get typeLine => text().named('type_line').nullable()();
  TextColumn get manaCost => text().named('mana_cost').nullable()();
  TextColumn get oracleText => text().named('oracle_text').nullable()();
  TextColumn get colorsJson => text().named('colors_json').nullable()();
  TextColumn get colorIdentityJson =>
      text().named('color_identity_json').nullable()();
  RealColumn get cmc => real().nullable()();
  TextColumn get rarity => text().nullable()();
  TextColumn get artist => text().nullable()();
  TextColumn get setName => text().named('set_name').nullable()();
  TextColumn get power => text().nullable()();
  TextColumn get toughness => text().nullable()();
  TextColumn get loyalty => text().nullable()();
  TextColumn get defense => text().nullable()();
  TextColumn get imageSmallUrl => text().named('image_small_url').nullable()();
  TextColumn get imageNormalUrl =>
      text().named('image_normal_url').nullable()();
  TextColumn get facesJson =>
      text().named('faces_json').withDefault(const Constant('[]'))();
  TextColumn get detailsJson => text().named('details_json').nullable()();
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
