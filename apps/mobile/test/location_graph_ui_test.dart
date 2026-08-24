import 'package:compass/app.dart';
import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:compass/theme/compass_theme_id.dart';
import 'package:compass/theme/theme_preferences_provider.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:compass/widgets/path_breadcrumbs.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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
    expect(find.text('Dashboard'), findsNothing);
    expect(find.text('Nothing here yet.'), findsNothing);

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    expect(find.text('Office'), findsOneWidget);

    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Desk');
    await tester.tap(find.text('Desk'));
    await tester.pumpAndSettle();
    expect(find.byType(PathBreadcrumbs), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(PathBreadcrumbs),
        matching: find.text('Office'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(PathBreadcrumbs),
        matching: find.text('Desk'),
      ),
      findsOneWidget,
    );

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

  testWidgets('asset breadcrumbs navigate to container and place',
      (tester) async {
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
    await tester.tap(
      find.ancestor(
        of: find.text('Lightning Bolt'),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Where'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Where'), findsOneWidget);
    expect(find.byType(PathBreadcrumbs), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(PathBreadcrumbs),
        matching: find.text('Binder'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add asset'), findsWidgets);

    await tester.tap(
      find.descendant(
        of: find.byType(PathBreadcrumbs),
        matching: find.text('Desk'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add container'), findsWidgets);

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('home button clears stack back to main page', (tester) async {
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

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Home'), findsOneWidget);
    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appName), findsWidgets);
    expect(find.text('Search by name'), findsOneWidget);
    expect(find.text('Add asset'), findsNothing);

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('container refetch all appears when assets are present',
      (tester) async {
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

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Refetch all'), findsNothing);

    await _addNamed(tester, buttonLabel: 'Add asset', name: 'Lightning Bolt');
    expect(find.byTooltip('Refetch all · Pro'), findsOneWidget);

    await tester.tap(find.byTooltip('Refetch all · Pro'));
    await tester.pumpAndSettle();
    expect(find.text('Refresh this container'), findsOneWidget);
    expect(
      find.textContaining('Bulk refetch is a Compass Pro feature'),
      findsOneWidget,
    );
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('detail chrome stays readable in light theme', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(container.dispose);

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

    await container.read(themePreferencesProvider.notifier).setThemeId(
          CompassThemeId.light,
        );
    await tester.pumpAndSettle();

    expect(find.text('Office'), findsWidgets);
    expect(find.text('Add place'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('Office').first)).brightness,
      Brightness.light,
    );

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('move container to another place updates search path',
      (tester) async {
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

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add place', name: 'Desk');
    await _addNamed(tester, buttonLabel: 'Add place', name: 'Shelf');
    await tester.tap(find.text('Desk'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add asset', name: 'Lightning Bolt');

    await tester.tap(find.byTooltip('Move'));
    await tester.pumpAndSettle();
    expect(find.text('Move Binder'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Shelf'));
    await tester.pumpAndSettle();

    // Binder → Desk → Office → Home
    for (var i = 0; i < 3; i++) {
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    expect(find.widgetWithText(TextField, 'Search by name'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'Search by name'),
      'Lightning',
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Office / Shelf / Binder / Lightning Bolt'),
      findsOneWidget,
    );

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('delete cancel keeps item; confirm removes from search',
      (tester) async {
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

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add asset', name: 'Lightning Bolt');
    await tester.tap(
      find.ancestor(
        of: find.text('Lightning Bolt'),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Delete asset?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Lightning Bolt'), findsWidgets);

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Lightning Bolt'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Search by name'),
      'Lightning',
    );
    await tester.pumpAndSettle();
    expect(find.text('No matches.'), findsOneWidget);
    expect(find.text('Lightning Bolt'), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextField, 'Search by name'),
      '',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete container?'), findsOneWidget);
    expect(
      find.textContaining('Assets inside will no longer be in this container'),
      findsNothing,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Binder'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete place?'), findsOneWidget);
    expect(
      find.textContaining('Nested places and containers'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Office'), findsWidgets);

    await database.close();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('name sheet cancel skips create; rename updates path',
      (tester) async {
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
    expect(find.byKey(namePromptSheetKey), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.byKey(namePromptSheetKey), findsNothing);
    expect(find.text('Office'), findsNothing);
    expect(
      find.text('Add a place to start mapping where things live.'),
      findsOneWidget,
    );

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add asset', name: 'Lightning Bolt');

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rename'));
    await tester.pumpAndSettle();
    expect(find.byKey(namePromptSheetKey), findsOneWidget);
    final field = find.descendant(
      of: find.byKey(namePromptSheetKey),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'Studio');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.text('Studio'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Search by name'),
      'Lightning',
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Studio / Binder / Lightning Bolt'),
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
    of: find.byKey(namePromptSheetKey),
    matching: find.byType(TextField),
  );
  await tester.enterText(field, name);
  await tester.tap(find.widgetWithText(FilledButton, 'Add'));
  await tester.pumpAndSettle();
}
