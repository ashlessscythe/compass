import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AssetDetailPage extends ConsumerWidget {
  const AssetDetailPage({required this.assetId, super.key});

  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsListProvider).valueOrNull ?? const [];
    final containers =
        ref.watch(containersListProvider).valueOrNull ?? const [];
    final assets = ref.watch(assetsListProvider).valueOrNull ?? const [];

    Asset? asset;
    for (final item in assets) {
      if (item.id == assetId) {
        asset = item;
        break;
      }
    }

    if (asset == null) {
      return const CompassScaffold(
        title: 'Asset',
        body: Center(child: Text('This asset is no longer here.')),
      );
    }

    final locationById = {for (final loc in locations) loc.id: loc};
    final containerById = {for (final item in containers) item.id: item};
    final path = assetPath(asset, locationById, containerById);

    return CompassScaffold(
      title: asset.name,
      actions: [
        IconButton(
          tooltip: 'Rename',
          onPressed: () => _rename(context, ref, asset!),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: 'Delete',
          onPressed: () => _delete(context, ref),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
      body: ListView(
        children: [
          Text('Where', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(path, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    Asset asset,
  ) async {
    final name = await promptForName(
      context,
      title: 'Rename asset',
      initial: asset.name,
    );
    if (name == null) {
      return;
    }
    final result = await ref.read(assetServiceProvider).renameAsset(
          id: asset.id,
          name: name,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(assetServiceProvider).deleteAsset(assetId);
    if (!context.mounted) {
      return;
    }
    if (result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
      return;
    }
    context.pop();
  }
}
