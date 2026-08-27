import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_mark.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Root launcher — pick an installed domain pack.
class DomainPickerPage extends ConsumerWidget {
  const DomainPickerPage({super.key});

  static Uri get moreDomainsUri =>
      Uri.https(AppConstants.domain, '/docs/domains');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final packsAsync = ref.watch(installedDomainPacksProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface.withValues(alpha: 0.35),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: packsAsync.when(
            data: (packs) => _PickerBody(packs: packs),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Failed to load domains: $error')),
          ),
        ),
      ),
    );
  }
}

class _PickerBody extends ConsumerWidget {
  const _PickerBody({required this.packs});

  final List<DomainPack> packs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: AppSpacing.pagePadding,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CompassMark(size: 36),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Select your domain',
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Each domain adds types, import formats, and catalog tools '
                  'on top of the shared location graph.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                ...packs.map(
                  (pack) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _DomainCard(
                      pack: pack,
                      onTap: () async {
                        await ref
                            .read(activeModuleIdProvider.notifier)
                            .setModule(pack.moduleId);
                        if (context.mounted) {
                          context.go(AppRoutes.domainHomePath(pack.moduleId));
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _openMoreDomains(context),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Get more domains'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openMoreDomains(BuildContext context) async {
    final launched = await launchUrl(
      DomainPickerPage.moreDomainsUri,
      mode: LaunchMode.externalApplication,
    );
    if (!context.mounted || launched) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open ${DomainPickerPage.moreDomainsUri}')),
    );
  }
}

class _DomainCard extends StatelessWidget {
  const _DomainCard({
    required this.pack,
    required this.onTap,
  });

  final DomainPack pack;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                _iconForModule(pack.moduleId),
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pack.displayName,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      pack.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForModule(String moduleId) {
    return switch (moduleId) {
      'mtg' => Icons.style_outlined,
      'jewelry' => Icons.diamond_outlined,
      'tools' => Icons.build_outlined,
      _ => Icons.category_outlined,
    };
  }
}
