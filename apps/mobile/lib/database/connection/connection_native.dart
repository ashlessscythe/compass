import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Native (iOS / Android / desktop) Drift connection.
QueryExecutor createExecutor() {
  return driftDatabase(
    name: 'compass',
    native: const DriftNativeOptions(
      databasePath: _resolveDatabasePath,
    ),
  );
}

Future<String> _resolveDatabasePath() async {
  try {
    final documents = await getApplicationDocumentsDirectory();
    return p.join(documents.path, 'compass.sqlite');
  } on MissingPlatformDirectoryException {
    // Headless / constrained environments may lack XDG directories.
    return p.join(Directory.systemTemp.path, 'compass.sqlite');
  }
}
