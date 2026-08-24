import 'package:compass/features/entitlements/application/entitlement_providers.dart';
import 'package:compass/features/entitlements/domain/entitlement_service.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Calm unlock sheet — Unlock Pro / Restore / Not now.
Future<void> showUnlockSheet(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String body,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
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
              Text(title, style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                body,
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                      color:
                          Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () async {
                  final result =
                      await ref.read(entitlementServiceProvider).purchase();
                  if (!sheetContext.mounted) {
                    return;
                  }
                  Navigator.of(sheetContext).pop();
                  if (!context.mounted) {
                    return;
                  }
                  _toastForResult(context, result, restore: false);
                },
                child: const Text('Unlock Pro'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () async {
                  final result =
                      await ref.read(entitlementServiceProvider).restore();
                  if (!sheetContext.mounted) {
                    return;
                  }
                  Navigator.of(sheetContext).pop();
                  if (!context.mounted) {
                    return;
                  }
                  _toastForResult(context, result, restore: true);
                },
                child: const Text('Restore'),
              ),
              TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                child: const Text('Not now'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _toastForResult(
  BuildContext context,
  EntitlementActionResult result, {
  required bool restore,
}) {
  final message = switch (result) {
    EntitlementActionResult.success =>
      restore ? 'Purchases restored' : 'Thank you for supporting Compass',
    EntitlementActionResult.cancelled => null,
    EntitlementActionResult.unavailable => restore
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
  );
}
