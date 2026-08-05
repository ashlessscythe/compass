import 'package:compass/app.dart';
import 'package:compass/bootstrap.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = await bootstrap();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CompassApp(),
    ),
  );
}
