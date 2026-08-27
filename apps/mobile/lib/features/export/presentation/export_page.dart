import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/export/application/export_service.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class ExportPage extends HookConsumerWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final exporting = useState(false);
    final assets = ref.watch(assetsListProvider);
    final count = assets.valueOrNull?.length ?? 0;

    return CompassScaffold(
      title: 'Export CSV',
      body: ListView(
        children: [
          Text(
            'Export your collection as a plain CSV you can edit in Sheets '
            'or Excel. Re-import detects Compass via the Path column.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Collection', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          assets.when(
            data: (_) => Text(
              count == 0
                  ? 'No assets to export yet.'
                  : '$count asset${count == 1 ? '' : 's'} will be included.',
              style: theme.textTheme.bodyMedium,
            ),
            loading: () => const Text('Counting assets…'),
            error: (_, _) => Text(
              'Could not load assets.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: exporting.value || count == 0
                ? null
                : () => _runExport(context, ref, exporting: exporting),
            child: exporting.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Export'),
          ),
        ],
      ),
    );
  }

  Future<void> _runExport(
    BuildContext context,
    WidgetRef ref, {
    required ValueNotifier<bool> exporting,
  }) async {
    exporting.value = true;
    final result = await ref.read(exportServiceProvider).exportToTempFile();
    exporting.value = false;
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

    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(summary.filePath, mimeType: 'text/csv')],
        subject: summary.fileName,
        sharePositionOrigin: origin,
      ),
    );

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported ${summary.assetCount} assets'),
      ),
    );
  }
}
