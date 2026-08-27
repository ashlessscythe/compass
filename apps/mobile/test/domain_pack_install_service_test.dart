import 'package:compass/database/app_database.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_manifest_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => '.',
    );
  });

  test('manifest repository caches and reloads packs', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final loader = DomainPackLoader();
    final repo = DomainPackManifestRepository(db);
    final pack = await loader.loadBundled('jewelry');
    final raw = await loader.loadBundledRaw('jewelry');

    await repo.upsertManifest(
      pack: pack,
      sourceUrl: loader.sourceUrlForPackId('jewelry'),
      manifestJson: raw,
    );

    final cached = await repo.loadCachedPacks();
    expect(cached, hasLength(1));
    expect(cached.first.id, 'jewelry');

    final row = await repo.rowForPackId('jewelry');
    expect(row?.sourceUrl, loader.sourceUrlForPackId('jewelry'));
    expect(row?.manifestJson, isNotEmpty);
  });
}
