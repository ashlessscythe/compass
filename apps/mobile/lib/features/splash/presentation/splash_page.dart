import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_colors.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

/// Brief branded splash that transitions to the home dashboard.
class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final opacity = useState<double>(0);

    useEffect(() {
      Future<void>.delayed(const Duration(milliseconds: 80), () {
        opacity.value = 1;
      });

      Future<void>.delayed(const Duration(milliseconds: 1400), () {
        if (context.mounted) {
          context.go(AppRoutes.home);
        }
      });
      return null;
    }, const []);

    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkBackground,
              Color(0xFF0E1219),
              AppColors.darkMuted,
            ],
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: opacity.value,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CompassMark(size: 72),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppConstants.tagline,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.foregroundMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
