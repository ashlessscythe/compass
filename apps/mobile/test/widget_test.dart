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

  testWidgets('empty home teaches add place, not dashboard', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: const CompassApp(),
      ),
    );

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appName), findsWidgets);
    expect(find.text(AppConstants.tagline), findsWidgets);
    expect(
      find.text('Add a place to start mapping where things live.'),
      findsOneWidget,
    );
    expect(find.text('Add place'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Add place'), findsOneWidget);
    expect(find.text('Dashboard'), findsNothing);
    expect(find.text('Nothing here yet.'), findsNothing);
    expect(find.byType(MaterialApp), findsOneWidget);

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('dashboard appears after the first place', (tester) async {
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

    await tester.tap(find.text('Add place'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      'Office',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Office'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(
      find.text('Add a place to start mapping where things live.'),
      findsNothing,
    );

    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Add a nested place or a container so things have somewhere to live.',
      ),
      findsOneWidget,
    );
    expect(find.text('Add place'), findsOneWidget);
    expect(find.text('Add container'), findsOneWidget);
    expect(find.text('No nested places yet.'), findsNothing);

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
