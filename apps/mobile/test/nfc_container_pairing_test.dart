import 'package:compass/database/app_database.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:compass/core/utils/result.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('pair NFC tag uid binds container; lookup opens it', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });
    await database.customSelect('SELECT 1').get();

    final office = (await container
            .read(locationServiceProvider)
            .createLocation(name: 'Office'))
        .valueOrNull!;
    final binder = (await container.read(containerServiceProvider).createContainer(
          name: 'Binder',
          locationId: office.id,
        ))
        .valueOrNull!;

    final paired = await container.read(containerServiceProvider).pairNfcTag(
          id: binder.id,
          nfcTagId: '04a1b2c3d4e5f6',
        );
    expect(paired.isSuccess, isTrue);
    expect(paired.valueOrNull!.nfcTagId, '04A1B2C3D4E5F6');

    final found = await container
        .read(containerServiceProvider)
        .findByNfcTagId('04a1b2c3d4e5f6');
    expect(found.valueOrNull!.id, binder.id);

    final other = (await container.read(containerServiceProvider).createContainer(
          name: 'Shelf box',
          locationId: office.id,
        ))
        .valueOrNull!;
    await container.read(containerServiceProvider).pairNfcTag(
          id: other.id,
          nfcTagId: '04A1B2C3D4E5F6',
        );
    final rebound = await container
        .read(containerServiceProvider)
        .findByNfcTagId('04A1B2C3D4E5F6');
    expect(rebound.valueOrNull!.id, other.id);

    final clearedBinder =
        await container.read(containerServiceProvider).getContainer(binder.id);
    expect(clearedBinder.valueOrNull!.nfcTagId, isNull);

    await container.read(containerServiceProvider).clearNfcTag(other.id);
    final missing = await container
        .read(containerServiceProvider)
        .findByNfcTagId('04A1B2C3D4E5F6');
    expect(missing.valueOrNull, isNull);
  });
}
