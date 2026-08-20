import 'package:compass/app.dart';
import 'package:compass/bootstrap.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create nested graph, then search shows path', (tester) async {
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

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Search by name'),
      'Lightning',
    );
    await tester.pumpAndSettle();

    expect(find.text('Lightning Bolt'), findsWidgets);
    expect(
      find.text('Office / Desk / Binder / Lightning Bolt'),
      findsOneWidget,
    );
  });
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
