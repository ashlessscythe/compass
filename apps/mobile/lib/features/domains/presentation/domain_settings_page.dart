import 'dart:async';

import 'package:compass/features/catalog/application/catalog_prefs.dart';
import 'package:compass/features/catalog/application/catalog_providers.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Domain-scoped collection tools (import, export, catalog for MTG).
class DomainSettingsPage extends ConsumerWidget {
  const DomainSettingsPage({required this.moduleId, super.key});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pack = ref.watch(domainPackRegistryProvider).valueOrNull?.packForModule(
          moduleId,
        );
    final catalogEnabled = ref.watch(catalogEnabledProvider);
    final catalogStatus = ref.watch(catalogStatusProvider);

    if (pack == null) {
      return const CompassScaffold(
        title: 'Domain',
        body: Center(child: Text('Domain pack not found.')),
      );
    }

    return CompassScaffold(
      title: pack.displayName,
      body: ListView(
        children: [
          Text(
            'Collection',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.upload_file_outlined),
            title: const Text('Import CSV'),
            subtitle: Text(
              'Import into ${pack.displayName} using pack CSV mappings',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.domainImportPath(moduleId)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.download_outlined),
            title: const Text('Export CSV'),
            subtitle: const Text('Plain CSV with Path column for Compass'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.domainExportPath(moduleId)),
          ),
          if (pack.providers.catalog?.id == 'scryfall') ...[
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Scryfall catalog',
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
              onTap:
                  catalogEnabled ? () => _downloadCatalog(context, ref) : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.image_not_supported_outlined),
              title: const Text('Clear image cache'),
              subtitle: const Text('Keeps card ids; removes cached art files'),
              onTap: () => _clearImages(context, ref),
            ),
          ],
        ],
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
