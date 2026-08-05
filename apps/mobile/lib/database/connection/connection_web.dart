import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Web Drift connection (IndexedDB / OPFS via WASM sqlite3).
QueryExecutor createExecutor() {
  return driftDatabase(
    name: 'compass',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
