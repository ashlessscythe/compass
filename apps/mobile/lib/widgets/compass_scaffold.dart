import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/theme/theme_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Shared page shell aligned with Home: soft gradient, padded body.
class CompassScaffold extends ConsumerWidget {
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

  void _goHome(BuildContext context, WidgetRef ref) {
    final moduleId = ref.read(activeModuleIdProvider);
    if (moduleId != null) {
      context.go(AppRoutes.domainHomePath(moduleId));
      return;
    }
    context.go(AppRoutes.domains);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final effectiveLeading = leading ??
        (canPop
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BackButton(),
                  IconButton(
                    tooltip: 'Home',
                    icon: const Icon(Icons.home_outlined),
                    onPressed: () => _goHome(context, ref),
                  ),
                ],
              )
            : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: effectiveLeading,
        leadingWidth: leading == null && canPop ? 96 : null,
        automaticallyImplyLeading: effectiveLeading == null,
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: ThemeBackdrop(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.scaffoldBackgroundColor.withValues(alpha: 0.92),
                theme.colorScheme.surface.withValues(alpha: 0.35),
                theme.scaffoldBackgroundColor.withValues(alpha: 0.92),
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
      ),
    );
  }
}
