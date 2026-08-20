import 'package:compass/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Shared page shell aligned with Home: soft gradient, padded body.
class CompassScaffold extends StatelessWidget {
  const CompassScaffold({
    required this.title,
    required this.body,
    super.key,
    this.actions,
    this.leading,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: leading,
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface.withValues(alpha: 0.35),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: body,
          ),
        ),
      ),
    );
  }
}
