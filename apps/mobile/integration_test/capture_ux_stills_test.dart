import 'package:compass/app.dart';
import 'package:compass/bootstrap.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';

/// Walks the graph UI and emits `<<<STILL:name>>>` markers for
/// `tool/capture_ux_stills.sh` (host takes `simctl` screenshots).
///
/// Run via the script — not as a plain CI test.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('emit still markers for UX-6 captures', (tester) async {
    final container = await bootstrap();
    addTearDown(container.dispose);
    final database = container.read(appDatabaseProvider);
    await database.delete(database.assets).go();
    await database.delete(database.containers).go();
    await database.delete(database.locations).go();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CompassApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    await _captureStill('01-empty-home');

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Desk');
    await tester.tap(find.text('Desk'));
    await tester.pumpAndSettle();

    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();

    await _addNamed(tester, buttonLabel: 'Add asset', name: 'Lightning Bolt');
    await _captureStill('05-container');

    await tester.tap(find.text('Lightning Bolt'));
    await tester.pumpAndSettle();
    expect(find.text('Where'), findsOneWidget);
    await _captureStill('06-asset-where');

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Office'), findsWidgets);
    await _captureStill('04-place');

    await tester.pageBack();
    await tester.pumpAndSettle();
    await _captureStill('02-home-graph');

    await tester.enterText(find.byKey(const Key('home_search_field')), 'Lightning');
    await tester.pumpAndSettle();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    expect(find.text('Office / Desk / Binder / Lightning Bolt'), findsOneWidget);
    await _captureStill('03-search-path');
  });
}

Future<void> _captureStill(String name) async {
  // Host script watches stdout and runs `simctl io … screenshot`.
  // ignore: avoid_print
  print('<<<STILL:$name>>>');
  await Future<void>.delayed(const Duration(milliseconds: 2200));
}

Future<void> _addNamed(
  WidgetTester tester, {
  required String buttonLabel,
  required String name,
}) async {
  await tester.ensureVisible(find.text(buttonLabel));
  await tester.tap(find.text(buttonLabel));
  await tester.pumpAndSettle();
  final field = find.descendant(
    of: find.byKey(namePromptSheetKey),
    matching: find.byType(TextField),
  );
  await tester.enterText(field, name);
  await tester.tap(find.widgetWithText(FilledButton, 'Add'));
  await tester.pumpAndSettle();
}
