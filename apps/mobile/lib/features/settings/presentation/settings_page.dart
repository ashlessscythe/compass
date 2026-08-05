import 'package:compass/theme/app_spacing.dart';
import 'package:compass/theme/theme_mode_provider.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Placeholder settings surface.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return CompassScaffold(
      title: 'Settings',
      body: ListView(
        children: [
          Text(
            'Appearance',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.brightness_auto_outlined),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (selection) {
              ref.read(themeModeProvider.notifier).mode = selection.first;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'More settings will arrive with future modules.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
