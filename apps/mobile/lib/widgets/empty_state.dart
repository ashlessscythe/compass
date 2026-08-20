import 'package:compass/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// First-run / empty-graph prompt: short copy and one or two add actions.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
    this.body,
    this.primaryIcon = Icons.add,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIcon = Icons.add,
  });

  final String? body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final IconData primaryIcon;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData secondaryIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryLabel = this.secondaryLabel;
    final onSecondary = this.onSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (body != null) ...[
          Text(body!, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.md),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FilledButton.icon(
              onPressed: onPrimary,
              icon: Icon(primaryIcon),
              label: Text(primaryLabel),
            ),
            if (secondaryLabel != null && onSecondary != null)
              OutlinedButton.icon(
                onPressed: onSecondary,
                icon: Icon(secondaryIcon),
                label: Text(secondaryLabel),
              ),
          ],
        ),
      ],
    );
  }
}

/// A titled graph list: empty becomes the add button;
/// filled lists get a quiet add.
class GraphChildSection extends StatelessWidget {
  const GraphChildSection({
    required this.title,
    required this.tiles,
    required this.addLabel,
    required this.onAdd,
    super.key,
  });

  final String title;
  final List<Widget> tiles;
  final String addLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (tiles.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: EmptyState(
              primaryLabel: addLabel,
              onPrimary: onAdd,
            ),
          )
        else ...[
          ...tiles,
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(addLabel),
            ),
          ),
        ],
      ],
    );
  }
}
