import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/compass_test_harness.dart';

void main() {
  setUp(setUpCompassWidgetTest);

  testWidgets('splash lands on domain picker before any home', (tester) async {
    final database = await pumpCompassApp(tester);

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);

    await settlePastSplash(tester);

    expect(find.text('Select your domain'), findsOneWidget);
    expect(find.text(CompassTestDomains.mtgDisplayName), findsOneWidget);
    expect(find.text(CompassTestDomains.jewelryDisplayName), findsOneWidget);
    expect(find.text('Add place'), findsNothing);
    expect(find.text('Dashboard'), findsNothing);

    await disposeCompassApp(tester, database);
  });

  testWidgets('empty domain home teaches add place, not dashboard',
      (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

    expect(find.text(CompassTestDomains.mtgDisplayName), findsWidgets);
    expect(find.text(CompassTestDomains.mtgHomeTagline), findsWidgets);
    expect(
      find.text('Add a place to start mapping where things live.'),
      findsOneWidget,
    );
    expect(find.text('Add place'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Add place'), findsOneWidget);
    expect(find.text('Dashboard'), findsNothing);
    expect(find.text('Nothing here yet.'), findsNothing);
    expect(find.byType(MaterialApp), findsOneWidget);

    await disposeCompassApp(tester, database);
  });

  testWidgets('dashboard appears after the first place', (tester) async {
    final database = await pumpCompassAtDomainHome(tester);

    await tester.tap(find.text('Add place'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byKey(namePromptSheetKey),
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

    await disposeCompassApp(tester, database);
  });
}
