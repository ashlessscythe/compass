import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/domains/application/module_scope.dart';
import 'package:compass/features/domains/application/pack_csv_adapter.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Pack-driven attribute editor for domain assets without a catalog provider.
class PackAttributeForm extends ConsumerStatefulWidget {
  const PackAttributeForm({
    required this.asset,
    required this.pack,
    super.key,
  });

  final Asset asset;
  final DomainPack pack;

  @override
  ConsumerState<PackAttributeForm> createState() => _PackAttributeFormState();
}

class _PackAttributeFormState extends ConsumerState<PackAttributeForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _textControllers;
  late Map<String, String?> _enumValues;
  var _editing = false;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _initFromAsset(widget.asset);
  }

  @override
  void didUpdateWidget(covariant PackAttributeForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing &&
        (oldWidget.asset.updatedAt != widget.asset.updatedAt ||
            oldWidget.asset.assetTypeId != widget.asset.assetTypeId)) {
      _disposeControllers();
      _initFromAsset(widget.asset);
    }
  }

  void _initFromAsset(Asset asset) {
    final adapter = PackCsvAdapter(widget.pack);
    _textControllers = {};
    _enumValues = {};
    for (final def in applicableAttributeDefinitions(
      widget.pack,
      asset.assetTypeId,
    )) {
      final raw = asset.metadata.values[def.key]?.toString();
      if (def.valueType == 'enum') {
        _enumValues[def.key] =
            raw != null && raw.isNotEmpty ? raw : null;
      } else {
        final display = def.valueType == 'enum'
            ? adapter.labelForAttributeValue(def.key, raw) ?? raw
            : raw;
        _textControllers[def.key] = TextEditingController(
          text: display ?? '',
        );
      }
    }
  }

  void _disposeControllers() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _startEditing() {
    setState(() => _editing = true);
  }

  void _cancelEditing() {
    _disposeControllers();
    _initFromAsset(widget.asset);
    setState(() => _editing = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);

    final adapter = PackCsvAdapter(widget.pack);
    final merged = Map<String, dynamic>.from(widget.asset.metadata.values);
    String? newAssetTypeId;

    for (final def in applicableAttributeDefinitions(
      widget.pack,
      widget.asset.assetTypeId,
    )) {
      if (def.valueType == 'enum') {
        final value = _enumValues[def.key];
        if (value == null || value.isEmpty) {
          merged.remove(def.key);
        } else {
          merged[def.key] = value;
          if (def.key == 'category') {
            final resolved =
                adapter.assetTypeIdForCategoryCanonical(value);
            if (resolved != null) {
              newAssetTypeId = resolved;
            }
          }
        }
      } else {
        final raw = _textControllers[def.key]?.text.trim() ?? '';
        if (raw.isEmpty) {
          merged.remove(def.key);
        } else {
          merged[def.key] = raw;
        }
      }
    }

    final result = await ref.read(assetServiceProvider).updatePackAttributes(
          id: widget.asset.id,
          metadata: Metadata(values: merged),
          assetTypeId: newAssetTypeId,
        );

    if (!mounted) {
      return;
    }
    setState(() {
      _saving = false;
      if (result.isSuccess) {
        _editing = false;
      }
    });

    if (result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adapter = PackCsvAdapter(widget.pack);
    final defs = applicableAttributeDefinitions(
      widget.pack,
      widget.asset.assetTypeId,
    );
    if (defs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Details', style: theme.textTheme.titleMedium),
            const Spacer(),
            if (!_editing)
              TextButton(
                onPressed: _saving ? null : _startEditing,
                child: const Text('Edit'),
              )
            else ...[
              TextButton(
                onPressed: _saving ? null : _cancelEditing,
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Form(
          key: _formKey,
          child: Column(
            children: [
              for (final def in defs)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _editing
                      ? _editField(context, def)
                      : _readRow(theme, adapter, def),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _readRow(
    ThemeData theme,
    PackCsvAdapter adapter,
    DomainPackAttributeDefinition def,
  ) {
    final raw = widget.asset.metadata.values[def.key]?.toString();
    final display = raw == null || raw.isEmpty
        ? 'Not set'
        : adapter.labelForAttributeValue(def.key, raw) ?? raw;
    final muted = raw == null || raw.isEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            def.displayName ?? def.key,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            display,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: muted ? theme.colorScheme.onSurfaceVariant : null,
              fontStyle: muted ? FontStyle.italic : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _editField(BuildContext context, DomainPackAttributeDefinition def) {
    final label = def.displayName ?? def.key;
    final unitSuffix =
        def.unit != null && def.unit!.isNotEmpty ? ' (${def.unit})' : '';

    switch (def.valueType) {
      case 'enum':
        final options = widget.pack.controlledValues
            .where((v) => v.vocabularyKey == def.vocabularyKey)
            .toList(growable: false);
        return DropdownButtonFormField<String?>(
          value: _enumValues[def.key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Not set'),
            ),
            for (final option in options)
              DropdownMenuItem<String?>(
                value: option.canonicalKey,
                child: Text(option.label),
              ),
          ],
          onChanged: (value) {
            setState(() => _enumValues[def.key] = value);
          },
        );
      case 'decimal':
      case 'currency':
        return TextFormField(
          controller: _textControllers[def.key],
          decoration: InputDecoration(
            labelText: '$label$unitSuffix',
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return null;
            }
            final normalized = value.trim().replaceAll(',', '');
            if (double.tryParse(normalized) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
        );
      default:
        return TextFormField(
          controller: _textControllers[def.key],
          decoration: InputDecoration(
            labelText: '$label$unitSuffix',
            border: const OutlineInputBorder(),
          ),
        );
    }
  }
}
