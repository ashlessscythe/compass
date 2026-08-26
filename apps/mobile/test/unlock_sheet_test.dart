import 'package:compass/features/entitlements/application/entitlement_providers.dart';
import 'package:compass/features/entitlements/domain/product_catalog.dart';
import 'package:compass/features/entitlements/infrastructure/fake_entitlement_service.dart';
import 'package:compass/features/entitlements/infrastructure/revenue_cat_entitlement_service.dart';
import 'package:compass/features/entitlements/presentation/unlock_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('themes unlock sheet offers Pro permanently and restore', (
    tester,
  ) async {
    final fake = FakeEntitlementService();
    addTearDown(fake.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          entitlementServiceProvider.overrideWithValue(fake),
        ],
        child: MaterialApp(
          home: HookConsumer(
            builder: (context, ref, _) {
              return Scaffold(
                body: TextButton(
                  onPressed: () => showThemesUnlockSheet(context, ref),
                  child: const Text('Open themes'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open themes'));
    await tester.pumpAndSettle();

    expect(find.text('Unlock ambience themes'), findsOneWidget);
    expect(find.textContaining('permanently'), findsOneWidget);
    expect(find.text('Unlock Pro'), findsOneWidget);
    expect(find.text('Restore'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);
  });

  testWidgets('sync sheet offers monthly yearly and restore', (tester) async {
    final fake = FakeEntitlementService();
    addTearDown(fake.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          entitlementServiceProvider.overrideWithValue(fake),
        ],
        child: MaterialApp(
          home: HookConsumer(
            builder: (context, ref, _) {
              return Scaffold(
                body: TextButton(
                  onPressed: () => showSyncUnlockSheet(context, ref),
                  child: const Text('Open sync'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open sync'));
    await tester.pumpAndSettle();

    expect(find.text('Compass Sync'), findsOneWidget);
    expect(find.textContaining('Local inventory always works'), findsOneWidget);
    expect(find.text('Subscribe monthly'), findsOneWidget);
    expect(find.text('Subscribe yearly'), findsOneWidget);
    expect(find.text('Restore'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);
  });

  test('packageForProduct prefers current offering then searches all', () {
    final lifetime = _package(
      ProductIds.proLifetime,
      PackageType.lifetime,
      offering: 'current',
    );
    final monthly = _package(
      ProductIds.syncMonthly,
      PackageType.monthly,
      offering: 'other',
    );
    final offerings = Offerings(
      {
        'current': Offering(
          'current',
          'Current',
          const {},
          [lifetime],
          lifetime: lifetime,
        ),
        'other': Offering(
          'other',
          'Other',
          const {},
          [monthly],
          monthly: monthly,
        ),
      },
      current: Offering(
        'current',
        'Current',
        const {},
        [lifetime],
        lifetime: lifetime,
      ),
    );

    expect(
      RevenueCatEntitlementService.packageForProduct(
        offerings,
        ProductIds.proLifetime,
      )?.storeProduct.identifier,
      ProductIds.proLifetime,
    );
    expect(
      RevenueCatEntitlementService.packageForProduct(
        offerings,
        ProductIds.syncMonthly,
      )?.storeProduct.identifier,
      ProductIds.syncMonthly,
    );
    expect(
      RevenueCatEntitlementService.packageForProduct(offerings, 'missing'),
      isNull,
    );
  });
}

Package _package(
  String productId,
  PackageType type, {
  required String offering,
}) {
  return Package(
    productId,
    type,
    StoreProduct(
      productId,
      'desc',
      productId,
      1,
      r'$1.00',
      'USD',
    ),
    PresentedOfferingContext(offering, null, null),
  );
}
