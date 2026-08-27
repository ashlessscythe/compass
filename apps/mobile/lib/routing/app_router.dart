import 'package:compass/features/about/presentation/about_page.dart';
import 'package:compass/features/assets/presentation/asset_detail_page.dart';
import 'package:compass/features/containers/presentation/container_detail_page.dart';
import 'package:compass/features/domains/presentation/domain_home_page.dart';
import 'package:compass/features/domains/presentation/domain_picker_page.dart';
import 'package:compass/features/domains/presentation/domain_settings_page.dart';
import 'package:compass/features/export/presentation/export_page.dart';
import 'package:compass/features/home/presentation/home_page.dart';
import 'package:compass/features/import/presentation/import_page.dart';
import 'package:compass/features/locations/presentation/location_detail_page.dart';
import 'package:compass/features/settings/presentation/settings_page.dart';
import 'package:compass/features/settings/presentation/themes_page.dart';
import 'package:compass/features/splash/presentation/splash_page.dart';
import 'package:compass/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Application router configuration.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.domains,
        name: 'domains',
        builder: (context, state) => const DomainPickerPage(),
      ),
      GoRoute(
        path: AppRoutes.domainHome,
        name: 'domainHome',
        builder: (context, state) => DomainHomePage(
          moduleId: state.pathParameters['moduleId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.domainSettings,
        name: 'domainSettings',
        builder: (context, state) => DomainSettingsPage(
          moduleId: state.pathParameters['moduleId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.domainImport,
        name: 'domainImport',
        builder: (context, state) => ImportPage(
          moduleId: state.pathParameters['moduleId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.domainExport,
        name: 'domainExport',
        builder: (context, state) => ExportPage(
          moduleId: state.pathParameters['moduleId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        redirect: (context, state) => AppRoutes.domains,
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.themes,
        name: 'themes',
        builder: (context, state) => const ThemesPage(),
      ),
      GoRoute(
        path: AppRoutes.importCsv,
        name: 'import',
        redirect: (context, state) => AppRoutes.domainImportPath('mtg'),
      ),
      GoRoute(
        path: AppRoutes.exportCsv,
        name: 'export',
        redirect: (context, state) => AppRoutes.domainExportPath('mtg'),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: AppRoutes.locationDetail,
        name: 'location',
        builder: (context, state) => LocationDetailPage(
          locationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.containerDetail,
        name: 'container',
        builder: (context, state) => ContainerDetailPage(
          containerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.assetDetail,
        name: 'asset',
        builder: (context, state) => AssetDetailPage(
          assetId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});
