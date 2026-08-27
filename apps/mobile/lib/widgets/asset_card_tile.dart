import 'dart:io';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/features/catalog/application/catalog_prefs.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:compass/features/catalog/presentation/catalog_match_actions.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/domains/application/domain_asset_catalog.dart';
import 'package:compass/theme/app_colors.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Container-list row; shows Scryfall match UI only for catalog-backed assets.
class AssetCardTile extends ConsumerWidget {
  const AssetCardTile({
    required this.asset,
    required this.onTap,
    required this.onMatch,
    super.key,
  });

  final Asset asset;
  final VoidCallback onTap;
  final VoidCallback onMatch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catalogPack = ref.watch(assetCatalogPackProvider(asset));
    final showCatalog = catalogPack != null;

    if (!showCatalog) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        child: Material(
          color: theme.colorScheme.surface.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  _GenericThumb(theme: theme),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(asset.name, style: theme.textTheme.titleMedium),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final enabled = ref.watch(catalogEnabledProvider);
    final scryfallId = MtgMetadataKeys.scryfallIdOf(asset.metadata.values);
    final matched = scryfallId != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Material(
        color: theme.colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _CatalogThumb(scryfallId: scryfallId),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(asset.name, style: theme.textTheme.titleMedium),
                ),
                if (!matched)
                  TextButton(
                    onPressed: enabled ? onMatch : null,
                    child: const Text('Match'),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenericThumb extends StatelessWidget {
  const _GenericThumb({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: 20,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      ),
    );
  }
}

class _CatalogThumb extends ConsumerWidget {
  const _CatalogThumb({this.scryfallId});

  final String? scryfallId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (scryfallId == null) {
      return CustomPaint(
        painter: _DashedBorderPainter(
          color: theme.colorScheme.outlineVariant,
        ),
        child: SizedBox(
          width: 40,
          height: 56,
          child: Icon(
            Icons.style_outlined,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    return FutureBuilder<File?>(
      future: loadCardImage(
        ref,
        scryfallId: scryfallId!,
        size: CardImageSize.small,
      ),
      builder: (context, snapshot) {
        final file = snapshot.data;
        if (file != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.file(
              file,
              width: 40,
              height: 56,
              fit: BoxFit.cover,
            ),
          );
        }
        return Container(
          width: 40,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.style_outlined, size: 18),
        );
      },
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const dash = 4.0;
    const gap = 3.0;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 1.5),
          const Radius.circular(6),
        ),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
