import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/nfc/application/nfc_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_colors.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_mark.dart';
import 'package:compass/widgets/empty_state.dart';
import 'package:compass/widgets/graph_tile.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final query = useState('');
    final assets = ref.watch(assetsListProvider);
    final containers = ref.watch(containersListProvider);
    final locations = ref.watch(locationsListProvider);
    final hits = query.value.trim().isEmpty
        ? const AsyncValue<List<SearchHit>>.data([])
        : ref.watch(searchHitsProvider(query.value));

    final assetCount = assets.valueOrNull?.length ?? 0;
    final containerCount = containers.valueOrNull?.length ?? 0;
    final locationCount = locations.valueOrNull?.length ?? 0;
    final rootPlaces = (locations.valueOrNull ?? const [])
        .where((item) => item.parentLocationId == null)
        .toList(growable: false);

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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                            tooltip: 'Scan NFC',
                            onPressed: () => _scanNfc(context, ref),
                            icon: const Icon(Icons.nfc_outlined),
                          ),
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
                      const SizedBox(height: AppSpacing.lg),
                      _HomeSearchField(
                        onChanged: (value) => query.value = value,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (query.value.trim().isNotEmpty)
                        _SearchResults(hits: hits)
                      else if (rootPlaces.isEmpty)
                        EmptyState(
                          body: 'Add a place to start mapping '
                              'where things live.',
                          primaryLabel: 'Add place',
                          onPrimary: () => _addPlace(context, ref),
                        )
                      else ...[
                        Text(
                          'Dashboard',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Browse places or search for an item.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.sm,
                          children: [
                            _MetricChip(label: 'Assets', value: assetCount),
                            _MetricChip(
                              label: 'Containers',
                              value: containerCount,
                            ),
                            _MetricChip(
                              label: 'Locations',
                              value: locationCount,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Places',
                          style: theme.textTheme.titleMedium,
                        ),
                        ...rootPlaces.map(
                          (item) => GraphTile(
                            title: item.name,
                            subtitle: item.path,
                            onTap: () => context.push(
                              AppRoutes.locationPath(item.id),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => _addPlace(context, ref),
                            icon: const Icon(Icons.add),
                            label: const Text('Add place'),
                          ),
                        ),
                      ],
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

  Future<void> _addPlace(BuildContext context, WidgetRef ref) async {
    final name = await promptForName(
      context,
      title: 'New place',
      confirmLabel: 'Add',
    );
    if (name == null) {
      return;
    }
    final result = await ref.read(locationServiceProvider).createLocation(
          name: name,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _scanNfc(BuildContext context, WidgetRef ref) async {
    final result =
        await ref.read(nfcServiceProvider).openContainerFromScan();
    if (!context.mounted) {
      return;
    }
    if (result.isFailure) {
      final failure = result.failureOrNull!;
      if (failure.message == 'NFC scan cancelled') {
        return;
      }
      showFailureSnackBar(context, failure.message);
      return;
    }
    await context.push(AppRoutes.containerPath(result.valueOrNull!.id));
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.hits});

  final AsyncValue<List<SearchHit>> hits;

  @override
  Widget build(BuildContext context) {
    return hits.when(
      data: (items) {
        if (items.isEmpty) {
          return const Text('No matches.');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Results', style: Theme.of(context).textTheme.titleMedium),
            ...items.map(
              (hit) => GraphTile(
                title: hit.name,
                subtitle: hit.path,
                icon: switch (hit.kind) {
                  SearchHitKind.location => Icons.place_outlined,
                  SearchHitKind.container => Icons.inventory_2_outlined,
                  SearchHitKind.asset => Icons.style_outlined,
                },
                onTap: () {
                  switch (hit.kind) {
                    case SearchHitKind.location:
                      context.push(AppRoutes.locationPath(hit.id));
                    case SearchHitKind.container:
                      context.push(AppRoutes.containerPath(hit.id));
                    case SearchHitKind.asset:
                      context.push(AppRoutes.assetPath(hit.id));
                  }
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Text('Search failed: $error'),
    );
  }
}

class _HomeSearchField extends HookWidget {
  const _HomeSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    useListenable(controller);

    return TextField(
      key: const Key('home_search_field'),
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'Search by name',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                tooltip: 'Clear',
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(Icons.close),
              )
            : null,
      ),
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      onSubmitted: (_) => focusNode.unfocus(),
      onTapOutside: (_) => focusNode.unfocus(),
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
