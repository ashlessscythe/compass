import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class CardStatRow {
  const CardStatRow(this.label, this.value);

  final String label;
  final String value;
}

String titleCase(String raw) {
  if (raw.isEmpty) {
    return raw;
  }
  return '${raw[0].toUpperCase()}${raw.substring(1)}';
}

String formatCmc(double? cmc) {
  if (cmc == null) {
    return '';
  }
  if (cmc == cmc.roundToDouble()) {
    return cmc.toInt().toString();
  }
  return cmc.toString();
}

List<CardStatRow> cardDetailRows({
  required CardPrinting printing,
  CardFace? face,
}) {
  final details = printing.details;
  final rows = <CardStatRow>[];

  void add(String label, String? value) {
    if (value != null && value.trim().isNotEmpty) {
      rows.add(CardStatRow(label, value.trim()));
    }
  }

  add('Flavor', face?.flavorText ?? details?.flavorText);
  if (details != null && details.keywords.isNotEmpty) {
    add('Keywords', details.keywords.join(', '));
  }
  if (details != null && details.finishes.isNotEmpty) {
    add('Finishes', details.finishes.join(', '));
  }
  if (details != null && details.promoTypes.isNotEmpty) {
    add('Promo types', details.promoTypes.join(', '));
  }
  if (details != null && details.frameEffects.isNotEmpty) {
    add('Frame effects', details.frameEffects.join(', '));
  }
  if (details != null && details.producedMana.isNotEmpty) {
    add('Produced mana', details.producedMana.join(', '));
  }

  final flags = <String>[
    if (details?.promo ?? false) 'promo',
    if (details?.reprint ?? false) 'reprint',
    if (details?.variation ?? false) 'variation',
    if (details?.fullArt ?? false) 'full art',
    if (details?.textless ?? false) 'textless',
    if (details?.oversized ?? false) 'oversized',
    if (details?.reserved ?? false) 'reserved',
    if (details?.digital ?? false) 'digital',
  ];
  if (flags.isNotEmpty) {
    add('Flags', flags.join(', '));
  }

  add('Frame', details?.frame);
  add('Border', details?.borderColor);
  add('Language', details?.lang);
  add('Released', details?.releasedAt);
  add('Set type', details?.setType);
  add('Layout', printing.layout);

  if (details != null) {
    final legal = details.legalities.entries
        .where((e) => e.value != 'not_legal')
        .map((e) => '${titleCase(e.key)}: ${e.value.replaceAll('_', ' ')}')
        .toList(growable: false);
    if (legal.isNotEmpty) {
      add('Legalities', legal.join('\n'));
    }

    final prices = <String>[
      if (details.usd != null) 'USD ${details.usd}',
      if (details.usdFoil != null) 'foil ${details.usdFoil}',
      if (details.eur != null) 'EUR ${details.eur}',
      if (details.tix != null) 'tix ${details.tix}',
    ];
    if (prices.isNotEmpty) {
      add('Scryfall prices', prices.join(' · '));
    }
  }

  return rows;
}

Future<void> showCardDetailsSheet(
  BuildContext context, {
  required CardPrinting printing,
  CardFace? face,
}) {
  final rows = cardDetailRows(printing: printing, face: face);
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final theme = Theme.of(context);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.35,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return SafeArea(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              children: [
                Text('Details', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                if (rows.isEmpty)
                  Text(
                    'No extra catalog details for this printing.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  for (final row in rows) ...[
                    Text(
                      row.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(row.value, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.md),
                  ],
              ],
            ),
          );
        },
      );
    },
  );
}
