import 'dart:async';

import 'package:compass/core/constants/sync_build_config.dart';
import 'package:compass/features/catalog/application/catalog_prefs.dart';
import 'package:compass/features/catalog/application/catalog_providers.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/entitlements/application/entitlement_providers.dart';
import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:compass/features/entitlements/presentation/unlock_sheet.dart';
import 'package:compass/features/sync/application/sync_providers.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Settings surface: themes, sync, import, MTG catalog.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catalogEnabled = ref.watch(catalogEnabledProvider);
    final catalogStatus = ref.watch(catalogStatusProvider);
    final canSync = ref.watch(canUseFeatureProvider(CompassFeature.cloudSync));
    final syncSession = ref.watch(syncSessionProvider);

    return CompassScaffold(
      title: 'Settings',
      body: ListView(
        children: [
          Text(
            'Appearance',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Themes'),
            subtitle: const Text('Dark, Light, Gray — and ambience skins'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.themes),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Sync',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (isDevSyncBuild) ...[
            Text(
              'Test build: Sync unlocked via dev secret. '
              'Remove before App Store release.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          ..._syncTiles(
            context,
            ref,
            canSync: canSync,
            syncSession: syncSession,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Collection',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.upload_file_outlined),
            title: const Text('Import CSV'),
            subtitle: const Text(
              'Deckbox, Moxfield, Compass, or generic collection CSV',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.importCsv),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.download_outlined),
            title: const Text('Export CSV'),
            subtitle: const Text(
              'Plain CSV of your collection (Path marks Compass)',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.exportCsv),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'MTG catalog',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Scryfall enrichment'),
            subtitle: const Text(
              'Look up card art and stats. Where-is-it still works when off.',
            ),
            value: catalogEnabled,
            onChanged: (value) {
              ref.read(catalogEnabledProvider.notifier).setEnabled(value);
            },
          ),
          catalogStatus.when(
            data: (CatalogStatus status) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.storage_outlined),
              title: Text(
                status.isInstalled
                    ? '${status.printingCount} cards cached'
                    : 'No local catalog yet',
              ),
              subtitle: Text(
                status.lastUpdatedAt == null
                    ? 'Download Scryfall default_cards for offline matching'
                    : 'Updated ${status.lastUpdatedAt!.toLocal()}',
              ),
            ),
            loading: () => const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Checking catalog…'),
            ),
            error: (error, _) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Catalog status unavailable: $error'),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.cloud_download_outlined),
            title: const Text('Download / update catalog'),
            subtitle: const Text('Wi‑Fi recommended — large download'),
            enabled: catalogEnabled,
            onTap: catalogEnabled ? () => _downloadCatalog(context, ref) : null,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.image_not_supported_outlined),
            title: const Text('Clear image cache'),
            subtitle: const Text('Keeps card ids; removes cached art files'),
            onTap: () => _clearImages(context, ref),
          ),
        ],
      ),
    );
  }

  List<Widget> _syncTiles(
    BuildContext context,
    WidgetRef ref, {
    required bool canSync,
    required AsyncValue<SyncSessionSnapshot> syncSession,
  }) {
    if (!canSync) {
      return [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.cloud_outlined),
          title: const Text('Compass Sync'),
          subtitle: const Text(
            'Backup and multi-device sync — requires Sync',
          ),
          trailing: const Icon(Icons.lock_outline),
          onTap: () => showSyncUnlockSheet(context, ref),
        ),
      ];
    }

    return syncSession.when(
      data: (session) {
        final tiles = <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              session.signedIn
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_outlined,
            ),
            title: Text(session.signedIn ? 'Signed in' : 'Not signed in'),
            subtitle: Text(
              session.lastSuccessAt == null
                  ? (session.apiConfigured
                        ? 'Sign in to push and pull your graph'
                        : 'Set COMPASS_API_BASE_URL to enable sync')
                  : 'Last synced ${session.lastSuccessAt!.toLocal()}',
            ),
          ),
        ];

        if (!session.signedIn) {
          tiles.add(
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.apple),
              title: const Text('Sign in with Apple'),
              enabled: session.apiConfigured,
              onTap: session.apiConfigured
                  ? () => _signInApple(context, ref)
                  : null,
            ),
          );
          final auth = ref.read(syncAuthControllerProvider);
          if (auth.canUseDevAuth) {
            tiles.add(
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.bug_report_outlined),
                title: const Text('Dev sign-in'),
                subtitle: Text(
                  kDebugMode ? 'Simulator / local API' : 'Test build dev auth',
                ),
                onTap: () => _signInDev(context, ref),
              ),
            );
          }
        } else {
          tiles.add(
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.sync),
              title: const Text('Sync now'),
              onTap: () => _syncNow(context, ref),
            ),
          );
          tiles.add(
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout),
              title: const Text('Sign out of Sync'),
              onTap: () => _signOut(context, ref),
            ),
          );
        }
        return tiles;
      },
      loading: () => [
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Checking sync…'),
        ),
      ],
      error: (error, _) => [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Sync status unavailable: $error'),
        ),
      ],
    );
  }

  Future<void> _signInApple(BuildContext context, WidgetRef ref) async {
    final error = await ref.read(syncAuthControllerProvider).signInWithApple();
    if (!context.mounted) {
      return;
    }
    if (error != null) {
      showFailureSnackBar(context, error);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed in for Sync')),
      );
    }
  }

  Future<void> _signInDev(BuildContext context, WidgetRef ref) async {
    final error = await ref.read(syncAuthControllerProvider).signInDev();
    if (!context.mounted) {
      return;
    }
    if (error != null) {
      showFailureSnackBar(context, error);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dev sync session ready')),
      );
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(syncAuthControllerProvider).signOut();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out of Sync')),
      );
    }
  }

  Future<void> _syncNow(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Syncing…')),
    );
    final result = await ref.read(syncAuthControllerProvider).syncNow();
    if (!context.mounted) {
      return;
    }
    if (!result.ok) {
      showFailureSnackBar(context, result.errorMessage ?? 'Sync failed');
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Synced — pushed ${result.pushed}, pulled ${result.pulled}',
        ),
      ),
    );
  }

  Future<void> _downloadCatalog(BuildContext context, WidgetRef ref) async {
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Downloading catalog…'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppSpacing.md),
              Text('Parsing into local SQLite. This can take a while.'),
            ],
          ),
        ),
      ),
    );
    try {
      await ref.read(mtgCardCatalogProvider).ensureCatalog(forceRefresh: true);
      ref.invalidate(catalogStatusProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catalog updated')),
        );
      }
    } on Object catch (error) {
      if (context.mounted) {
        showFailureSnackBar(context, 'Catalog download failed: $error');
      }
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<void> _clearImages(BuildContext context, WidgetRef ref) async {
    await ref.read(cardImageCacheProvider).clear();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image cache cleared')),
      );
    }
  }
}
