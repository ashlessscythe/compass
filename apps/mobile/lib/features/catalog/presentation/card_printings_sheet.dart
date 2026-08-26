import 'dart:io';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/catalog/application/catalog_providers.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:compass/features/catalog/presentation/card_details_sheet.dart';
import 'package:compass/features/catalog/presentation/catalog_match_actions.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showCardPrintingsSheet(
  BuildContext context,
  WidgetRef ref, {
  required Asset asset,
  required CardPrinting current,
  required bool catalogEnabled,
}) {
  final oracleId = current.oracleId;
  if (oracleId == null || oracleId.isEmpty) {
    return Future.value();
  }
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return _PrintingsSheet(
        asset: asset,
        currentId: current.id,
        oracleId: oracleId,
        catalogEnabled: catalogEnabled,
      );
    },
  );
}

class _PrintingsSheet extends ConsumerStatefulWidget {
  const _PrintingsSheet({
    required this.asset,
    required this.currentId,
    required this.oracleId,
    required this.catalogEnabled,
  });

  final Asset asset;
  final String currentId;
  final String oracleId;
  final bool catalogEnabled;

  @override
  ConsumerState<_PrintingsSheet> createState() => _PrintingsSheetState();
}

class _PrintingsSheetState extends ConsumerState<_PrintingsSheet> {
  late Future<List<CardPrinting>> _printings;
  var _networkFailed = false;
  var _binding = false;

  @override
  void initState() {
    super.initState();
    _printings = _load();
  }

  Future<List<CardPrinting>> _load() async {
    final catalog = ref.read(mtgCardCatalogProvider);
    final local = await catalog.listPrints(
      widget.oracleId,
      allowNetwork: false,
    );
    if (!widget.catalogEnabled) {
      _networkFailed = local.length <= 1;
      return local;
    }
    try {
      final remote = await catalog.listPrints(widget.oracleId);
      if (remote.length > 1 || remote.length > local.length) {
        _networkFailed = false;
        return remote;
      }
      _networkFailed = remote.isEmpty && local.length <= 1;
      return remote.isEmpty ? local : remote;
    } on Object {
      _networkFailed = local.length <= 1;
      return local;
    }
  }

  Future<void> _select(CardPrinting printing) async {
    if (_binding || printing.id == widget.currentId) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _binding = true);
    final result = await ref.read(cardMatchServiceProvider).bindPrinting(
          widget.asset,
          printing,
        );
    if (!mounted) {
      return;
    }
    if (result.isFailure) {
      setState(() => _binding = false);
      showFailureSnackBar(context, result.failureOrNull!.message);
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return SafeArea(
          child: FutureBuilder(
            future: _printings,
            builder: (context, snapshot) {
              final items = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    child: Text(
                      'Other printings',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (_binding ||
                      snapshot.connectionState != ConnectionState.done)
                    const LinearProgressIndicator(),
                  if (_networkFailed && (items == null || items.length <= 1))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: Text(
                        'Need network to load other printings.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  Expanded(
                    child: items == null
                        ? const SizedBox.shrink()
                        : ListView.builder(
                            controller: controller,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final printing = items[index];
                              final selected = printing.id == widget.currentId;
                              return _PrintingTile(
                                printing: printing,
                                selected: selected,
                                enabled: !_binding,
                                onTap: () => _select(printing),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _PrintingTile extends ConsumerWidget {
  const _PrintingTile({
    required this.printing,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final CardPrinting printing;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final setLabel = printing.setName?.isNotEmpty ?? false
        ? printing.setName!
        : printing.setCode.toUpperCase();
    final subtitleParts = <String>[
      printing.setCode.toUpperCase(),
      '#${printing.collectorNumber}',
      if (printing.rarity != null && printing.rarity!.isNotEmpty)
        titleCase(printing.rarity!),
      if (printing.artist != null && printing.artist!.isNotEmpty)
        printing.artist!,
    ];
    final promo = printing.details?.isPromoLike ?? false;

    return ListTile(
      selected: selected,
      enabled: enabled,
      onTap: onTap,
      leading: _PrintingThumb(printing: printing),
      title: Text(setLabel),
      subtitle: Text(subtitleParts.join(' · ')),
      trailing: selected
          ? Icon(Icons.check, color: theme.colorScheme.primary)
          : promo
              ? const Chip(
                  label: Text('Promo'),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                )
              : null,
    );
  }
}

class _PrintingThumb extends ConsumerWidget {
  const _PrintingThumb({required this.printing});

  final CardPrinting printing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<File?>(
      future: loadCardImage(
        ref,
        scryfallId: printing.id,
        size: CardImageSize.small,
        urlOverride: printing.imageUrlForFace(0, normal: false),
      ),
      builder: (context, snapshot) {
        final file = snapshot.data;
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: 40,
            height: 56,
            child: file == null
                ? ColoredBox(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    child: const Icon(Icons.style_outlined, size: 20),
                  )
                : Image.file(file, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
