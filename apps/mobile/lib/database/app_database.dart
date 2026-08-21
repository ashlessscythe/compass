import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/database/connection/connection.dart';
import 'package:compass/database/migrations/migrations.dart';
import 'package:compass/database/tables/asset_types.dart';
import 'package:compass/database/tables/assets.dart';
import 'package:compass/database/tables/card_printings.dart';
import 'package:compass/database/tables/containers.dart';
import 'package:compass/database/tables/locations.dart';
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
