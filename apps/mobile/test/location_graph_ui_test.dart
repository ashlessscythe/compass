import 'package:compass/app.dart';
import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create nested graph then search shows path', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: const CompassApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appName), findsWidgets);
    expect(find.text('Add place'), findsOneWidget);

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    expect(find.text('Office'), findsOneWidget);

    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Desk');
    await tester.tap(find.text('Desk'));
    await tester.pumpAndSettle();
    expect(find.text('Office / Desk'), findsWidgets);

    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();

    await _addNamed(tester, buttonLabel: 'Add asset', name: 'Lightning Bolt');
    expect(find.text('Lightning Bolt'), findsOneWidget);

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

    expect(find.text('Lightning Bolt'), findsOneWidget);
    expect(
      find.text('Office / Desk / Binder / Lightning Bolt'),
      findsOneWidget,
    );

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

Future<void> _addNamed(
  WidgetTester tester, {
  required String buttonLabel,
  required String name,
}) async {
  await tester.tap(find.text(buttonLabel));
  await tester.pumpAndSettle();
  final field = find.descendant(
    of: find.byType(AlertDialog),
    matching: find.byType(TextField),
  );
  await tester.enterText(field, name);
  await tester.tap(find.widgetWithText(FilledButton, 'Add'));
  await tester.pumpAndSettle();
}
