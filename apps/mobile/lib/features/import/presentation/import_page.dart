import 'dart:convert';

import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/presentation/catalog_match_actions.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/import/application/import_service.dart';
import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/move_target_picker.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImportPage extends HookConsumerWidget {
  const ImportPage({this.moduleId = 'mtg', super.key});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fileName = useState<String?>(null);
    final parseResult = useState<CsvParseResult?>(null);
    final parseError = useState<String?>(null);
    final selectedContainer = useState<graph.Container?>(null);
    final importing = useState(false);
    final containers = ref.watch(containersListProvider);
    final locations = ref.watch(locationsListProvider);
    final isCompass = parseResult.value?.dialectId.isCompass ?? false;
    final canImport = parseResult.value != null &&
        (isCompass || selectedContainer.value != null) &&
        !importing.value;

    return CompassScaffold(
      title: 'Import CSV',
      body: ListView(
        children: [
          Text(
            isCompass
                ? 'Compass CSV detected — places and containers come from '
                    'each row’s Path. No destination container needed.'
                : 'Import a Compass export or spreadsheet CSV into a container. '
                    'Items become searchable with that path.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('File', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: importing.value
                ? null
                : () => _pickFile(
                      context,
                      ref,
                      fileName: fileName,
                      parseResult: parseResult,
                      parseError: parseError,
                      selectedContainer: selectedContainer,
                    ),
            icon: const Icon(Icons.upload_file_outlined),
            label: Text(fileName.value ?? 'Choose CSV'),
          ),
          if (parseError.value != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              parseError.value!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          if (parseResult.value != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Detected ${parseResult.value!.dialectId.label} · '
              '${parseResult.value!.rowCount} item${parseResult.value!.rowCount == 1 ? '' : 's'}'
              '${_skippedLabel(parseResult.value!)}',
              style: theme.textTheme.bodyMedium,
            ),
            if (parseResult.value!.rowCount >
                CsvCollectionParser.warnRowThreshold)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'Large file — import may take a moment.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
          if (!isCompass) ...[
            const SizedBox(height: AppSpacing.xl),
            Text('Destination', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: importing.value || parseResult.value == null
                  ? null
                  : () => _pickContainer(
                        context,
                        containers: containers.valueOrNull ?? const [],
                        locations: locations.valueOrNull ?? const [],
                        selected: selectedContainer,
                      ),
              icon: const Icon(Icons.inventory_2_outlined),
              label: Text(
                selectedContainer.value?.name ?? 'Choose container',
              ),
            ),
            if (selectedContainer.value != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                containerPath(
                  selectedContainer.value!,
                  {
                    for (final item
                        in locations.valueOrNull ?? const <Location>[])
                      item.id: item,
                  },
                  {
                    for (final item
                        in containers.valueOrNull ?? const <graph.Container>[])
                      item.id: item,
                  },
                ),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: !canImport
                ? null
                : () => _runImport(
                      context,
                      ref,
                      moduleId: moduleId,
                      parsed: parseResult.value!,
                      container: selectedContainer.value,
                      importing: importing,
                    ),
            child: importing.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Import'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(
    BuildContext context,
    WidgetRef ref, {
    required ValueNotifier<String?> fileName,
    required ValueNotifier<CsvParseResult?> parseResult,
    required ValueNotifier<String?> parseError,
    required ValueNotifier<graph.Container?> selectedContainer,
  }) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      withData: true,
    );
    if (picked == null || picked.files.isEmpty) {
      return;
    }
    final file = picked.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      parseError.value = 'Could not read the selected file.';
      parseResult.value = null;
      fileName.value = null;
      return;
    }

    final content = utf8.decode(bytes, allowMalformed: true);
    final result = ref.read(importServiceProvider(moduleId)).parseCsv(content);
    if (result.isFailure) {
      parseError.value = result.failureOrNull!.message;
      parseResult.value = null;
      fileName.value = file.name;
      return;
    }

    parseError.value = null;
    parseResult.value = result.valueOrNull;
    fileName.value = file.name;
    if (result.valueOrNull?.dialectId.isCompass ?? false) {
      selectedContainer.value = null;
    }
  }

  Future<void> _pickContainer(
    BuildContext context, {
    required List<graph.Container> containers,
    required List<Location> locations,
    required ValueNotifier<graph.Container?> selected,
  }) async {
    final locationById = {for (final item in locations) item.id: item};
    final containerById = {for (final item in containers) item.id: item};
    final destinations = [
      for (final item in containers)
        MoveDestination(
          key: item.id,
          label: item.name,
          subtitle: containerPath(item, locationById, containerById),
          icon: Icons.inventory_2_outlined,
        ),
    ];

    final picked = await pickMoveDestination(
      context,
      title: 'Import into container',
      destinations: destinations,
    );
    if (picked == null) {
      return;
    }
    selected.value = containerById[picked.key];
  }

  Future<void> _runImport(
    BuildContext context,
    WidgetRef ref, {
    required String moduleId,
    required CsvParseResult parsed,
    required graph.Container? container,
    required ValueNotifier<bool> importing,
  }) async {
    importing.value = true;
    final service = ref.read(importServiceProvider(moduleId));
    final result = parsed.dialectId.isCompass
        ? await service.importCompassPaths(parsed: parsed)
        : await service.importIntoContainer(
            parsed: parsed,
            containerId: container!.id,
          );
    importing.value = false;
    if (!context.mounted) {
      return;
    }
    if (result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
      return;
    }
    final summary = result.valueOrNull;
    if (summary == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          parsed.dialectId.isCompass
              ? 'Imported ${summary.createdCount} items from CSV paths'
              : 'Imported ${summary.createdCount} items into '
                  '${summary.destinationLabel}',
        ),
      ),
    );

    if (moduleId != 'mtg') {
      return;
    }

    final match = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Match with Scryfall?'),
        content: const Text(
          'Check the local card catalog (download if needed), '
          'dedupe rows, and attach art ids for thumbs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Match'),
          ),
        ],
      ),
    );
    if (match != true || !context.mounted) {
      return;
    }

    final assets = ref.read(assetsListProvider).valueOrNull ?? const [];
    final idSet = summary.createdAssetIds.toSet();
    final created = assets
        .where((item) => idSet.contains(item.id))
        .toList(growable: false);
    await runCardMatchForAssets(context, ref, assets: created);
  }
}

String _skippedLabel(CsvParseResult parsed) {
  if (parsed.skippedEmptyNames <= 0) {
    return '';
  }
  return ' (${parsed.skippedEmptyNames} empty rows skipped)';
}
