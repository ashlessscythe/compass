import 'package:compass/database/connection/connection_stub.dart'
    if (dart.library.io) 'package:compass/database/connection/connection_native.dart'
    if (dart.library.js_interop) 'package:compass/database/connection/connection_web.dart';
import 'package:drift/drift.dart';

/// Opens the platform-appropriate Drift connection.
QueryExecutor openConnection() => createExecutor();
