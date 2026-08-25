import 'package:compass/features/sync/domain/sync_apply_order.dart';
import 'package:compass/features/sync/domain/sync_change.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sortChangesForApply', () {
    SyncChange upsert(
      SyncEntityType type,
      String id, {
      String? parentLocationId,
      String? parentContainerId,
    }) {
      return SyncChange(
        entityType: type,
        entityId: id,
        op: SyncOp.upsert,
        updatedAt: DateTime.utc(2026, 8, 25),
        payload: {
          'id': id,
          'name': id,
          if (parentLocationId != null) 'parentLocationId': parentLocationId,
          if (parentContainerId != null)
            'parentContainerId': parentContainerId,
        },
      );
    }

    test('orders upserts before deletes and parents before children', () {
      final sorted = sortChangesForApply([
        upsert(SyncEntityType.asset, 'asset-1'),
        SyncChange(
          entityType: SyncEntityType.location,
          entityId: 'old',
          op: SyncOp.delete,
          updatedAt: DateTime.utc(2026, 8, 25),
        ),
        upsert(
          SyncEntityType.location,
          'child',
          parentLocationId: 'parent',
        ),
        upsert(SyncEntityType.location, 'parent'),
        upsert(SyncEntityType.container, 'box', parentContainerId: 'outer'),
        upsert(SyncEntityType.container, 'outer'),
        upsert(SyncEntityType.assetType, 'type'),
      ]);

      final types = sorted.map((c) => '${c.op.wire}:${c.entityType.wire}:${c.entityId}').toList();
      expect(types.indexOf('upsert:asset_type:type'), lessThan(types.indexOf('upsert:location:parent')));
      expect(types.indexOf('upsert:location:parent'), lessThan(types.indexOf('upsert:location:child')));
      expect(types.indexOf('upsert:container:outer'), lessThan(types.indexOf('upsert:container:box')));
      expect(types.indexOf('upsert:asset:asset-1'), lessThan(types.indexOf('delete:location:old')));
    });
  });
}
