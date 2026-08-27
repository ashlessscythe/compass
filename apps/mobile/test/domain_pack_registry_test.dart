import 'dart:convert';

import 'package:compass/database/app_database.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_manifest_repository.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_seeder.dart';
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

  test('registry prefers newer cached manifest over bundled', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final loader = DomainPackLoader();
    final repo = DomainPackManifestRepository(db);
    final raw = await loader.loadBundledRaw('jewelry');
    final bumped = raw.replaceFirst('"version": "1.0.0"', '"version": "9.9.9"');
    final pack = DomainPack.fromJson(
      jsonDecode(bumped) as Map<String, dynamic>,
    );

    await repo.upsertManifest(
      pack: pack,
      sourceUrl: loader.sourceUrlForPackId('jewelry'),
      manifestJson: bumped,
    );

    final registry = DomainPackRegistry(
      loader: loader,
      seeder: DomainPackSeeder(db),
      manifestRepository: repo,
    );
    await registry.initialize();

    expect(registry.packById('jewelry')?.version, '9.9.9');
    expect(registry.installedPacks.length, 2);
  });
}
