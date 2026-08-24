import 'package:compass/features/entitlements/application/entitlement_providers.dart';
import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:compass/features/entitlements/domain/entitlement_service.dart';
import 'package:compass/features/entitlements/domain/product_catalog.dart';
import 'package:compass/features/entitlements/infrastructure/fake_entitlement_service.dart';
import 'package:compass/features/entitlements/presentation/unlock_sheet.dart';
import 'package:compass/theme/app_colors.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/theme/app_theme.dart';
import 'package:compass/theme/color_utils.dart';
import 'package:compass/theme/compass_theme_id.dart';
import 'package:compass/theme/theme_preferences_provider.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Settings → Themes: free trio, Pro ambience, gated accent.
class ThemesPage extends ConsumerWidget {
  const ThemesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(themePreferencesProvider);
    final canThemes =
        ref.watch(canUseFeatureProvider(CompassFeature.advancedThemes));
    final canAccent =
        ref.watch(canUseFeatureProvider(CompassFeature.customAccent));
    final theme = Theme.of(context);
    final entitlement = ref.watch(entitlementServiceProvider);

    return CompassScaffold(
      title: 'Themes',
      body: ListView(
        children: [
          Text('Free', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final id in CompassThemeIdX.freeThemes)
                _ThemePreviewCard(
                  id: id,
                  selected: prefs.themeId == id,
                  locked: false,
                  onTap: () => ref
                      .read(themePreferencesProvider.notifier)
                      .setThemeId(id),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text('Ambience', style: theme.textTheme.titleMedium),
              ),
              if (!canThemes)
                TextButton(
                  onPressed: () => showThemesUnlockSheet(context, ref),
                  child: const Text('Unlock Pro'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final id in CompassThemeIdX.paidThemes)
                _ThemePreviewCard(
                  id: id,
                  selected: prefs.themeId == id && canThemes,
                  locked: !canThemes,
                  onTap: () async {
                    if (!canThemes) {
                      await showThemesUnlockSheet(context, ref);
                      return;
                    }
                    await ref
                        .read(themePreferencesProvider.notifier)
                        .setThemeId(id);
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Accent', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (!canAccent)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: AppColors.accent,
                radius: 14,
              ),
              title: const Text('Cool steel'),
              subtitle: const Text('Custom accents unlock with Compass Pro'),
              onTap: () => showThemesUnlockSheet(context, ref),
            )
          else ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final color in _accentSwatches)
                  _AccentDot(
                    color: color,
                    selected: colorsEqual(prefs.customAccent, color) ||
                        (prefs.customAccent == null &&
                            colorsEqual(color, AppColors.accent)),
                    onTap: () {
                      ref
                          .read(themePreferencesProvider.notifier)
                          .setCustomAccent(
                            colorsEqual(color, AppColors.accent) ? null : color,
                          );
                    },
                  ),
                _AccentDot(
                  color: prefs.customAccent ?? theme.colorScheme.primary,
                  selected: prefs.customAccent != null &&
                      !_accentSwatches.any(
                        (c) => colorsEqual(c, prefs.customAccent),
                      ),
                  label: 'Custom',
                  onTap: () =>
                      _pickCustomAccent(context, ref, prefs.customAccent),
                ),
              ],
            ),
            TextButton(
              onPressed: () => ref
                  .read(themePreferencesProvider.notifier)
                  .setCustomAccent(null),
              child: const Text('Reset to steel'),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          if (canThemes)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Compass Pro'),
              subtitle: const Text('Themes and bulk refetch unlocked'),
              trailing: TextButton(
                onPressed: () async {
                  final result =
                      await ref.read(entitlementServiceProvider).restore();
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result == EntitlementActionResult.success
                            ? 'Purchases restored'
                            : 'Nothing new to restore',
                      ),
                    ),
                  );
                },
                child: const Text('Restore'),
              ),
            )
          else
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Unlock Compass Pro'),
              subtitle: const Text(
                'Ambience themes, custom accent, and container refetch',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showThemesUnlockSheet(context, ref),
            ),
          if (kDebugMode && entitlement is FakeEntitlementService)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Debug tier'),
              subtitle: Text(_tierLabel(entitlement.tier)),
              trailing: DropdownButton<EntitlementTier>(
                value: entitlement.tier,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  entitlement.setTier(value);
                },
                items: [
                  for (final tier in EntitlementTier.values)
                    DropdownMenuItem(
                      value: tier,
                      child: Text(_tierLabel(tier)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static String _tierLabel(EntitlementTier tier) => switch (tier) {
        EntitlementTier.free => 'Free',
        EntitlementTier.pro => 'Pro',
        EntitlementTier.sync => 'Sync',
        EntitlementTier.syncPlus => 'Sync+',
      };

  Future<void> _pickCustomAccent(
    BuildContext context,
    WidgetRef ref,
    Color? current,
  ) async {
    var draft = current ?? AppColors.accent;
    final picked = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Custom accent'),
          content: StatefulBuilder(
            builder: (context, setState) {
              final hsv = HSVColor.fromColor(draft);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(backgroundColor: draft, radius: 28),
                  const SizedBox(height: AppSpacing.md),
                  Text('Hue', style: Theme.of(context).textTheme.labelMedium),
                  Slider(
                    value: hsv.hue,
                    max: 360,
                    onChanged: (hue) {
                      setState(() {
                        draft = hsv.withHue(hue).toColor();
                      });
                    },
                  ),
                  Text(
                    'Saturation',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Slider(
                    value: hsv.saturation,
                    onChanged: (sat) {
                      setState(() {
                        draft = hsv.withSaturation(sat).toColor();
                      });
                    },
                  ),
                  Text(
                    'Brightness',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Slider(
                    value: hsv.value,
                    onChanged: (v) {
                      setState(() {
                        draft = hsv.withValue(v).toColor();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, draft),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
    if (picked != null) {
      await ref.read(themePreferencesProvider.notifier).setCustomAccent(picked);
    }
  }
}

const List<Color> _accentSwatches = [
  AppColors.accent,
  Color(0xFF5EC8C0),
  Color(0xFFC48B5A),
  Color(0xFFB07AD6),
  Color(0xFFE07A7A),
];

class _ThemePreviewCard extends StatelessWidget {
  const _ThemePreviewCard({
    required this.id,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final CompassThemeId id;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final preview = AppTheme.from(id);
    final borderColor = selected
        ? scheme.primary
        : scheme.onSurface.withValues(alpha: 0.45);

    return Material(
      color: scheme.surface,
      elevation: selected ? 2 : 1,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: selected ? 2 : 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 104,
          height: 88,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      preview.scaffoldBackgroundColor,
                      preview.colorScheme.surface,
                      preview.colorScheme.primary.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
              // Bottom scrim so the label stays readable on any skin.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                right: 10,
                child: Text(
                  id.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (locked)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccentDot extends StatelessWidget {
  const _AccentDot({
    required this.color,
    required this.selected,
    required this.onTap,
    this.label,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(label!, style: Theme.of(context).textTheme.labelSmall),
        ],
      ],
    );
  }
}
