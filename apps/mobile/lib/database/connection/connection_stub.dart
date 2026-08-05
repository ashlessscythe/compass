import 'package:drift/drift.dart';

/// Stub used when neither native nor web libraries are available.
QueryExecutor createExecutor() {
  throw UnsupportedError(
    'No suitable Drift connection for this platform.',
  );
}
