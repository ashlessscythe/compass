import 'package:compass/theme/compass_theme_id.dart';
import 'package:compass/theme/theme_preferences_provider.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:compass/widgets/path_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/compass_test_harness.dart';

void main() {
  setUp(setUpCompassWidgetTest);

  testWidgets('create nested graph then search shows path', (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

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

    await disposeCompassApp(tester, database);
  });

  testWidgets('asset breadcrumbs navigate to container and place',
      (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

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
    await tester.tap(find.text('Lightning Bolt'));
    await tester.pumpAndSettle();

    // Domain asset detail: path lives in the top breadcrumbs (no separate
    // "Where" heading — catalog-backed MTG cards use match UI below).
    expect(find.byType(PathBreadcrumbs), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(PathBreadcrumbs),
        matching: find.text('Lightning Bolt'),
      ),
      findsOneWidget,
    );

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

    await disposeCompassApp(tester, database);
  });

  testWidgets('home button clears stack back to domain home', (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Home'), findsOneWidget);
    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();

    expect(find.text(CompassTestDomains.mtgDisplayName), findsWidgets);
    expect(find.text('Search by name'), findsOneWidget);
    expect(find.text('Add asset'), findsNothing);

    await disposeCompassApp(tester, database);
  });

  testWidgets('container refetch all appears when assets are present',
      (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

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

    await disposeCompassApp(tester, database);
  });

  testWidgets('detail chrome stays readable in light theme', (tester) async {
    final harness = createCompassTestContainer();
    addTearDown(harness.container.dispose);

    final database = await pumpCompassAtDomainHome(
      tester,
      container: harness.container,
      database: harness.database,
    );

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();

    await harness.container.read(themePreferencesProvider.notifier).setThemeId(
          CompassThemeId.light,
        );
    await tester.pumpAndSettle();

    expect(find.text('Office'), findsWidgets);
    expect(find.text('Add place'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('Office').first)).brightness,
      Brightness.light,
    );

    await disposeCompassApp(tester, database);
  });

  testWidgets('move container to another place updates search path',
      (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

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

    await disposeCompassApp(tester, database);
  });

  testWidgets('delete cancel keeps item; confirm removes from search',
      (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

    await _addNamed(tester, buttonLabel: 'Add place', name: 'Office');
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add container', name: 'Binder');
    await tester.tap(find.text('Binder'));
    await tester.pumpAndSettle();
    await _addNamed(tester, buttonLabel: 'Add asset', name: 'Lightning Bolt');
    await tester.tap(find.text('Lightning Bolt'));
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

    await disposeCompassApp(tester, database);
  });

  testWidgets('name sheet cancel skips create; rename updates path',
      (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

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

    await disposeCompassApp(tester, database);
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
