import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_mark.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:flutter/material.dart';

/// Placeholder about surface.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CompassScaffold(
      title: 'About',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CompassMark(size: 56),
          const SizedBox(height: AppSpacing.lg),
          Text(AppConstants.appName, style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(AppConstants.tagline, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Offline-first asset management. Built around Assets, '
            'Containers, and Locations — not any single hobby or '
            'inventory type.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppConstants.domain,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
