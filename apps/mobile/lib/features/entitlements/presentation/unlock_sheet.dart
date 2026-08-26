import 'dart:async';

import 'package:compass/features/entitlements/application/entitlement_providers.dart';
import 'package:compass/features/entitlements/domain/entitlement_service.dart';
import 'package:compass/features/entitlements/domain/product_catalog.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Calm unlock sheet — purchase / Restore / Not now.
Future<void> showUnlockSheet(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String body,
  required String productId,
  String ctaLabel = 'Unlock Pro',
}) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return _UnlockSheet(
        toastContext: context,
        title: title,
        body: body,
        actions: [
          _PurchaseAction(productId: productId, label: ctaLabel, filled: true),
        ],
      );
    },
  );
}

/// Sync paywall: monthly, yearly, restore. Local inventory always works.
Future<void> showSyncUnlockSheet(BuildContext context, WidgetRef ref) {
  const debugHint = kDebugMode ? ' Debug: Themes → Debug tier → Sync.' : '';
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return _UnlockSheet(
        toastContext: context,
        title: 'Compass Sync',
        body:
            'Keep your collection synchronized and backed up across '
            'devices. Local inventory always works offline.$debugHint',
        actions: const [
          _PurchaseAction(
            productId: ProductIds.syncMonthly,
            label: 'Subscribe monthly',
            filled: true,
          ),
          _PurchaseAction(
            productId: ProductIds.syncYearly,
            label: 'Subscribe yearly',
            filled: false,
          ),
        ],
      );
    },
  );
}

class _PurchaseAction {
  const _PurchaseAction({
    required this.productId,
    required this.label,
    required this.filled,
  });

  final String productId;
  final String label;
  final bool filled;
}

class _UnlockSheet extends ConsumerWidget {
  const _UnlockSheet({
    required this.toastContext,
    required this.title,
    required this.body,
    required this.actions,
  });

  final BuildContext toastContext;
  final String title;
  final String body;
  final List<_PurchaseAction> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final action in actions) ...[
              _PricedPurchaseButton(
                action: action,
                toastContext: toastContext,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            TextButton(
              onPressed: () async {
                final result = await ref
                    .read(entitlementServiceProvider)
                    .restore();
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pop();
                if (!toastContext.mounted) {
                  return;
                }
                toastForEntitlementResult(
                  toastContext,
                  result,
                  restore: true,
                );
              },
              child: const Text('Restore'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Not now'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricedPurchaseButton extends ConsumerStatefulWidget {
  const _PricedPurchaseButton({
    required this.action,
    required this.toastContext,
  });

  final _PurchaseAction action;
  final BuildContext toastContext;

  @override
  ConsumerState<_PricedPurchaseButton> createState() =>
      _PricedPurchaseButtonState();
}

class _PricedPurchaseButtonState extends ConsumerState<_PricedPurchaseButton> {
  String? _price;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadPrice());
    });
  }

  Future<void> _loadPrice() async {
    final label = await ref
        .read(entitlementServiceProvider)
        .priceLabel(widget.action.productId);
    if (!mounted || label == null || label.isEmpty) {
      return;
    }
    setState(() => _price = label);
  }

  @override
  Widget build(BuildContext context) {
    final text = _price == null
        ? widget.action.label
        : '${widget.action.label} · $_price';
    Future<void> onPressed() async {
      final result = await ref
          .read(entitlementServiceProvider)
          .purchaseProduct(widget.action.productId);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
      if (!widget.toastContext.mounted) {
        return;
      }
      toastForEntitlementResult(widget.toastContext, result, restore: false);
    }

    if (widget.action.filled) {
      return FilledButton(onPressed: onPressed, child: Text(text));
    }
    return OutlinedButton(onPressed: onPressed, child: Text(text));
  }
}

@visibleForTesting
void toastForEntitlementResult(
  BuildContext context,
  EntitlementActionResult result, {
  required bool restore,
}) {
  final message = switch (result) {
    EntitlementActionResult.success =>
      restore ? 'Purchases restored' : 'Thank you for supporting Compass',
    EntitlementActionResult.cancelled => null,
    EntitlementActionResult.unavailable =>
      restore
          ? 'No purchase found to restore'
          : 'Purchases are unavailable right now',
    EntitlementActionResult.failed =>
      restore ? 'Could not restore purchases' : 'Purchase did not complete',
  };
  if (message == null) {
    return;
  }
  if (result == EntitlementActionResult.success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } else {
    showFailureSnackBar(context, message);
  }
}

Future<void> showThemesUnlockSheet(BuildContext context, WidgetRef ref) {
  return showUnlockSheet(
    context,
    ref,
    title: 'Unlock ambience themes',
    body:
        'Compass Pro unlocks ambience skins, a custom accent, and bulk '
        'container refetch permanently. Dark, Light, and Gray stay free.',
    productId: ProductIds.proLifetime,
  );
}

Future<void> showRefetchUnlockSheet(BuildContext context, WidgetRef ref) {
  return showUnlockSheet(
    context,
    ref,
    title: 'Refresh this container',
    body:
        'Bulk refetch is a Compass Pro feature. You can still match cards '
        'one at a time — thanks for considering supporting Compass.',
    productId: ProductIds.proLifetime,
  );
}
