import 'package:compass/app.dart';
import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bundled MTG pack copy as shown after splash → domain picker → domain home.
///
/// MTG has no `tagline` in its manifest, so DomainHomePage falls back to
/// this subtitle for `moduleId == 'mtg'`.
abstract final class CompassTestDomains {
  static const String mtgModuleId = 'mtg';
  static const String mtgDisplayName = 'Magic: The Gathering';
  static const String mtgHomeTagline = 'Know where every card is.';

  static const String jewelryModuleId = 'jewelry';
  static const String jewelryDisplayName = 'Jewelry';
}

/// Splash delay used by SplashPage before navigating to the domain picker.
const Duration compassSplashDuration = Duration(milliseconds: 1600);

/// Shared prefs + binding setup required by domain registry / active module.
void setUpCompassWidgetTest() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
}

/// Creates an in-memory DB + [ProviderContainer] for tests that need direct
/// notifier access (e.g. theme preferences).
({AppDatabase database, ProviderContainer container})
    createCompassTestContainer({
  List<Override> overrides = const [],
  AppDatabase? database,
}) {
  final db = database ?? AppDatabase.forTesting(NativeDatabase.memory());
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      ...overrides,
    ],
  );
  return (database: db, container: container);
}

/// Pumps [CompassApp] with an in-memory database (and optional overrides).
Future<AppDatabase> pumpCompassApp(
  WidgetTester tester, {
  List<Override> overrides = const [],
  AppDatabase? database,
  ProviderContainer? container,
}) async {
  if (container != null) {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CompassApp(),
      ),
    );
    return container.read(appDatabaseProvider);
  }

  final db = database ?? AppDatabase.forTesting(NativeDatabase.memory());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        ...overrides,
      ],
      child: const CompassApp(),
    ),
  );
  return db;
}

/// Advances past the branded splash onto the domain picker.
Future<void> settlePastSplash(WidgetTester tester) async {
  expect(find.text(AppConstants.appName), findsOneWidget);
  expect(find.text(AppConstants.tagline), findsOneWidget);

  await tester.pump(compassSplashDuration);
  await tester.pumpAndSettle();

  expect(find.text('Select your domain'), findsOneWidget);
}

/// Opens an installed domain from the picker (default: MTG).
Future<void> openDomainHome(
  WidgetTester tester, {
  String displayName = CompassTestDomains.mtgDisplayName,
}) async {
  expect(find.text('Select your domain'), findsOneWidget);
  await tester.ensureVisible(find.text(displayName));
  await tester.tap(find.text(displayName));
  await tester.pumpAndSettle();
}

/// Full cold-launch path used by the product: splash → picker → domain home.
Future<AppDatabase> pumpCompassAtDomainHome(
  WidgetTester tester, {
  List<Override> overrides = const [],
  AppDatabase? database,
  ProviderContainer? container,
  String displayName = CompassTestDomains.mtgDisplayName,
  String homeTitle = CompassTestDomains.mtgDisplayName,
  String homeTagline = CompassTestDomains.mtgHomeTagline,
}) async {
  final db = await pumpCompassApp(
    tester,
    overrides: overrides,
    database: database,
    container: container,
  );
  await settlePastSplash(tester);
  await openDomainHome(tester, displayName: displayName);

  expect(find.text(homeTitle), findsWidgets);
  expect(find.text(homeTagline), findsWidgets);
  return db;
}

/// Tears down a widget test database and unmounts the tree.
Future<void> disposeCompassApp(
  WidgetTester tester,
  AppDatabase database,
) async {
  await database.close();
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}
