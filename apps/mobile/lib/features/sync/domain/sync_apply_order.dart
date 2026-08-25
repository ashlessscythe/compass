import 'package:compass/features/sync/domain/sync_change.dart';

/// Apply upserts parents-before-children; apply deletes children-first.
List<SyncChange> sortChangesForApply(List<SyncChange> changes) {
  final deletes =
      changes.where((change) => change.op == SyncOp.delete).toList();
  final upserts =
      changes.where((change) => change.op == SyncOp.upsert).toList();

  final types = upserts
      .where((change) => change.entityType == SyncEntityType.assetType)
      .toList();
  final locations = _sortByParent(
    upserts
        .where((change) => change.entityType == SyncEntityType.location)
        .toList(),
    parentId: (payload) => payload['parentLocationId'] as String?,
  );
  final containers = _sortByParent(
    upserts
        .where((change) => change.entityType == SyncEntityType.container)
        .toList(),
    parentId: (payload) => payload['parentContainerId'] as String?,
  );
  final assets = upserts
      .where((change) => change.entityType == SyncEntityType.asset)
      .toList();

  deletes.sort(
    (a, b) => _applyRank(b.entityType).compareTo(_applyRank(a.entityType)),
  );

  return [
    ...types,
    ...locations,
    ...containers,
    ...assets,
    ...deletes,
  ];
}

int _applyRank(SyncEntityType type) {
  return switch (type) {
    SyncEntityType.assetType => 0,
    SyncEntityType.location => 1,
    SyncEntityType.container => 2,
    SyncEntityType.asset => 3,
  };
}

List<SyncChange> _sortByParent(
  List<SyncChange> items, {
  required String? Function(Map<String, dynamic> payload) parentId,
}) {
  if (items.length <= 1) {
    return items;
  }
  final byId = {for (final item in items) item.entityId: item};
  final sorted = <SyncChange>[];
  final visited = <String>{};

  void visit(SyncChange change) {
    if (visited.contains(change.entityId)) {
      return;
    }
    final payload = change.payload;
    if (payload != null) {
      final parent = parentId(payload);
      if (parent != null && byId.containsKey(parent)) {
        visit(byId[parent]!);
      }
    }
    visited.add(change.entityId);
    sorted.add(change);
  }

  for (final item in items) {
    visit(item);
  }
  return sorted;
}
