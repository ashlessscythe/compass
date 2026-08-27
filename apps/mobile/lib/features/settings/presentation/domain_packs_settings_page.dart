import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/domains/application/domain_pack_install_service.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/presentation/domain_picker_page.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DomainPacksSettingsPage extends ConsumerStatefulWidget {
  const DomainPacksSettingsPage({super.key});

  @override
  ConsumerState<DomainPacksSettingsPage> createState() =>
      _DomainPacksSettingsPageState();
}

class _DomainPacksSettingsPageState
    extends ConsumerState<DomainPacksSettingsPage> {
  final _urlController = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text != null && text.isNotEmpty) {
      _urlController.text = text;
    }
  }

  Future<void> _installOrUpdate() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      showFailureSnackBar(context, 'Enter a domain pack URL');
      return;
    }
    await _runInstall(() {
      return ref.read(domainPackInstallServiceProvider).installOrUpdateFromUrl(
            url,
          );
    });
  }

  Future<void> _updatePack(String packId) async {
    await _runInstall(() {
      return ref.read(domainPackInstallServiceProvider).updatePack(packId);
    });
  }

  Future<void> _updateAll() async {
    setState(() => _busy = true);
    final service = ref.read(domainPackInstallServiceProvider);
    final result = await service.updateAll();
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    if (result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
      return;
    }
    invalidateDomainPackRegistry(ref);
    final updated = result.valueOrNull!
        .where((item) => item.outcome == DomainPackInstallOutcome.updated)
        .length;
    final message = updated == 0
        ? 'All domain packs are up to date'
        : 'Updated $updated domain pack${updated == 1 ? '' : 's'}';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() {});
  }

  Future<void> _runInstall(
    Future<Result<DomainPackInstallOutcome>> Function() action,
  ) async {
    setState(() => _busy = true);
    final result = await action();
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    if (result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
      return;
    }
    invalidateDomainPackRegistry(ref);
    final message = switch (result.valueOrNull!) {
      DomainPackInstallOutcome.installed => 'Domain pack installed',
      DomainPackInstallOutcome.updated => 'Domain pack updated',
      DomainPackInstallOutcome.unchanged => 'Domain pack is already up to date',
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() {});
  }

  Future<void> _openDocs() async {
    final launched = await launchUrl(
      DomainPickerPage.moreDomainsUri,
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || launched) {
      return;
    }
    showFailureSnackBar(context, 'Could not open ${DomainPickerPage.moreDomainsUri}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registryAsync = ref.watch(domainPackRegistryProvider);

    return CompassScaffold(
      title: 'Domain packs',
      body: registryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load packs: $error')),
        data: (registry) => _buildBody(context, theme, registry),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    DomainPackRegistry registry,
  ) {
    final installService = ref.read(domainPackInstallServiceProvider);
    return FutureBuilder<Result<List<InstalledDomainPackInfo>>>(
      future: installService.listInstalled(
        packsById: {for (final pack in registry.installedPacks) pack.id: pack},
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final listResult = snapshot.data!;
        if (listResult.isFailure) {
          return Center(child: Text(listResult.failureOrNull!.message));
        }
        final installed = listResult.valueOrNull ?? const [];

        return ListView(
          padding: AppSpacing.pagePadding,
          children: [
            Text(
              'Install or update',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Copy a pack URL from getcompass.space/docs/domains and paste it '
              'below. The same URL checks for updates later.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Pack URL',
                hintText: '${AppConstants.domainPackApiBaseUrl}/jewelry',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: 'Paste',
                  onPressed: _busy ? null : _pasteFromClipboard,
                  icon: const Icon(Icons.content_paste_outlined),
                ),
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
              enabled: !_busy,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _busy ? null : _installOrUpdate,
              child: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Install or update'),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Text('Installed', style: theme.textTheme.titleMedium),
                const Spacer(),
                TextButton(
                  onPressed: _busy ? null : _updateAll,
                  child: const Text('Check all for updates'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (installed.isEmpty)
              Text(
                'No domain packs installed yet.',
                style: theme.textTheme.bodyMedium,
              )
            else
              ...installed.map(
                (info) => _InstalledPackTile(
                  info: info,
                  busy: _busy,
                  onUpdate: () => _updatePack(info.packId),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: _busy ? null : _openDocs,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Browse domains on web'),
            ),
          ],
        );
      },
    );
  }
}

class _InstalledPackTile extends StatelessWidget {
  const _InstalledPackTile({
    required this.info,
    required this.busy,
    required this.onUpdate,
  });

  final InstalledDomainPackInfo info;
  final bool busy;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final source = info.sourceUrl;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(info.displayName, style: theme.textTheme.titleMedium),
                ),
                if (info.isBundled)
                  Chip(
                    label: Text(
                      'Bundled',
                      style: theme.textTheme.labelSmall,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('v${info.version}', style: theme.textTheme.bodySmall),
            if (source != null && source.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                source,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: busy ? null : onUpdate,
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
