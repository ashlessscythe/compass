/// Wire entity kinds for sync v0.
enum SyncEntityType {
  location('location'),
  container('container'),
  asset('asset'),
  assetType('asset_type');

  const SyncEntityType(this.wire);
  final String wire;

  static SyncEntityType fromWire(String value) {
    return SyncEntityType.values.firstWhere((e) => e.wire == value);
  }
}

enum SyncOp {
  upsert('upsert'),
  delete('delete');

  const SyncOp(this.wire);
  final String wire;

  static SyncOp fromWire(String value) {
    return SyncOp.values.firstWhere((e) => e.wire == value);
  }
}

class SyncChange {
  const SyncChange({
    required this.entityType,
    required this.entityId,
    required this.op,
    required this.updatedAt,
    this.payload,
    this.localId,
  });

  factory SyncChange.fromWire(Map<String, dynamic> json) {
    return SyncChange(
      entityType: SyncEntityType.fromWire(json['entityType'] as String),
      entityId: json['entityId'] as String,
      op: SyncOp.fromWire(json['op'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
      payload: json['payload'] as Map<String, dynamic>?,
    );
  }

  final SyncEntityType entityType;
  final String entityId;
  final SyncOp op;
  final DateTime updatedAt;
  final Map<String, dynamic>? payload;
  final int? localId;

  Map<String, dynamic> toWire() => {
        'entityType': entityType.wire,
        'entityId': entityId,
        'op': op.wire,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        if (payload != null) 'payload': payload,
      };
}
