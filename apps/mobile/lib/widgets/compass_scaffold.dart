import 'package:compass/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Shared page shell with consistent padding and optional app bar actions.
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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: leading,
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: body,
        ),
      ),
    );
  }
}
