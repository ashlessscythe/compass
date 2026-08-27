import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/home/presentation/home_page.dart';
import 'package:compass/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Domain-scoped location graph home (MTG first).
class DomainHomePage extends ConsumerStatefulWidget {
  const DomainHomePage({required this.moduleId, super.key});

  final String moduleId;

  @override
  ConsumerState<DomainHomePage> createState() => _DomainHomePageState();
}

class _DomainHomePageState extends ConsumerState<DomainHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(activeModuleIdProvider.notifier).setModule(widget.moduleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final registryAsync = ref.watch(domainPackRegistryProvider);
    final pack = registryAsync.valueOrNull?.packForModule(widget.moduleId);

    if (pack == null && registryAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (pack == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This domain is not installed.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.domains),
                child: const Text('Back to domains'),
              ),
            ],
          ),
        ),
      );
    }

    return HomePage(
      title: pack.displayName,
      subtitle: pack.tagline ??
          (widget.moduleId == 'mtg'
              ? 'Know where every card is.'
              : 'Know where everything is.'),
      moduleId: widget.moduleId,
      onBackToDomains: () => context.go(AppRoutes.domains),
      onOpenDomainSettings: () =>
          context.push(AppRoutes.domainSettingsPath(widget.moduleId)),
    );
  }
}
