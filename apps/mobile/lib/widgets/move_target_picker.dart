import 'package:compass/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class MoveDestination {
  const MoveDestination({
    required this.key,
    required this.label,
    this.subtitle,
    this.icon = Icons.place_outlined,
  });

  /// Stable id for the chosen target
  /// (e.g. `root`, `location:…`, `container:…`).
  final String key;
  final String label;
  final String? subtitle;
  final IconData icon;
}

Future<MoveDestination?> pickMoveDestination(
  BuildContext context, {
  required String title,
  required List<MoveDestination> destinations,
}) {
  return showModalBottomSheet<MoveDestination>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final theme = Theme.of(context);
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            if (destinations.isEmpty)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text('No other destinations yet.'),
              )
            else
              for (final destination in destinations)
                ListTile(
                  leading: Icon(destination.icon),
                  title: Text(destination.label),
                  subtitle: destination.subtitle == null
                      ? null
                      : Text(destination.subtitle!),
                  onTap: () => Navigator.of(context).pop(destination),
                ),
          ],
        ),
      );
    },
  );
}
