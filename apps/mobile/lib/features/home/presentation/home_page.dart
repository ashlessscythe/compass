import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_colors.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_mark.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Placeholder home dashboard — brand, tagline, and empty module slots.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final assets = ref.watch(assetsListProvider);
    final containers = ref.watch(containersListProvider);
    final locations = ref.watch(locationsListProvider);

    final assetCount = assets.valueOrNull?.length ?? 0;
    final containerCount = containers.valueOrNull?.length ?? 0;
    final locationCount = locations.valueOrNull?.length ?? 0;

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
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: AppSpacing.pagePadding,
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CompassMark(size: 36),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Settings',
                            onPressed: () => context.push(AppRoutes.settings),
                            icon: const Icon(Icons.settings_outlined),
                          ),
                          IconButton(
                            tooltip: 'About',
                            onPressed: () => context.push(AppRoutes.about),
                            icon: const Icon(Icons.info_outline),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppConstants.tagline,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        'Dashboard',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Your inventory overview will live here.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _DashboardPlaceholder(
                        assetCount: assetCount,
                        containerCount: containerCount,
                        locationCount: locationCount,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder({
    required this.assetCount,
    required this.containerCount,
    required this.locationCount,
  });

  final int assetCount;
  final int containerCount;
  final int locationCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nothing here yet',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Assets, containers, and locations will appear once '
              'you start organizing.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                _MetricChip(label: 'Assets', value: assetCount),
                _MetricChip(label: 'Containers', value: containerCount),
                _MetricChip(label: 'Locations', value: locationCount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.accentSoft,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
