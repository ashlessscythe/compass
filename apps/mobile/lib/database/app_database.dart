import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/database/connection/connection.dart';
import 'package:compass/database/migrations/migrations.dart';
import 'package:compass/database/tables/asset_types.dart';
import 'package:compass/database/tables/assets.dart';
import 'package:compass/database/tables/card_printings.dart';
import 'package:compass/database/tables/containers.dart';
import 'package:compass/database/tables/domain_pack_tables.dart';
import 'package:compass/database/tables/locations.dart';
import 'package:compass/database/tables/sync_tables.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Local SQLite database for Compass.
@DriftDatabase(
  tables: [
    Locations,
    Containers,
    AssetTypes,
    Assets,
    CardPrintings,
    CatalogMeta,
    SyncOutbox,
    SyncState,
    InstalledDomainPacks,
    PackAttributeDefinitions,
    PackControlledValues,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  /// Visible for testing with an in-memory executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => DatabaseMigrations.schemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createAll();
          } else {
            if (from < 3) {
              await m.addColumn(assets, assets.quantity);
              await m.addColumn(assetTypes, assetTypes.parentId);
            }
            if (from < 4) {
              await m.createTable(cardPrintings);
              await m.createTable(catalogMeta);
            }
            if (from < 5) {
              await m.addColumn(cardPrintings, cardPrintings.layout);
              await m.addColumn(cardPrintings, cardPrintings.facesJson);
            }
            if (from < 6) {
              await m.createTable(syncOutbox);
              await m.createTable(syncState);
            }
            if (from < 7) {
              await m.addColumn(cardPrintings, cardPrintings.oracleText);
              await m.addColumn(cardPrintings, cardPrintings.colorsJson);
              await m.addColumn(
                cardPrintings,
                cardPrintings.colorIdentityJson,
              );
              await m.addColumn(cardPrintings, cardPrintings.cmc);
              await m.addColumn(cardPrintings, cardPrintings.rarity);
              await m.addColumn(cardPrintings, cardPrintings.artist);
              await m.addColumn(cardPrintings, cardPrintings.setName);
              await m.addColumn(cardPrintings, cardPrintings.power);
              await m.addColumn(cardPrintings, cardPrintings.toughness);
              await m.addColumn(cardPrintings, cardPrintings.loyalty);
              await m.addColumn(cardPrintings, cardPrintings.defense);
              await m.addColumn(cardPrintings, cardPrintings.detailsJson);
              await customStatement(
                'CREATE INDEX IF NOT EXISTS '
                'card_printings_oracle_id_idx ON card_printings (oracle_id)',
              );
            }
            if (from < 8) {
              await m.createTable(installedDomainPacks);
              await m.createTable(packAttributeDefinitions);
              await m.createTable(packControlledValues);
            }
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await _seedDefaultAssetType();
        },
      );

  Future<void> _seedDefaultAssetType() async {
    final existing = await (select(assetTypes)
          ..where((t) => t.id.equals(AppConstants.defaultAssetTypeId)))
        .getSingleOrNull();
    if (existing != null) {
      return;
    }

    final now = DateTime.now().toUtc();
    await into(assetTypes).insert(
      AssetTypesCompanion.insert(
        id: AppConstants.defaultAssetTypeId,
        name: AppConstants.defaultAssetTypeName,
        moduleId: AppConstants.defaultModuleId,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}
