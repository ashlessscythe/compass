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

  testWidgets('shows brand name and tagline on home', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: const CompassApp(),
      ),
    );

    // Splash first
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);

    // Advance past splash delay to home
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appName), findsWidgets);
    expect(find.text(AppConstants.tagline), findsWidgets);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
