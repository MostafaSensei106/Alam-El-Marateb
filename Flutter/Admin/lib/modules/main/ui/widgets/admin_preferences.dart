import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/localization/logic/cubit/localization_cubit.dart';
import '../../../../core/utils/theme/logic/cubit/theme_cubit.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';

/// One selectable option inside an [AdminSegmentedControl].
final class AdminSegment<T> {
  const AdminSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// Segmented control that stretches to the available width.
///
/// `SegmentedButton` overflows on narrow cards, so the admin shell uses this
/// compact implementation instead.
final class AdminSegmentedControl<T> extends StatelessWidget {
  const AdminSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<AdminSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadii.large),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _AdminSegmentButton<T>(
                segment: segment,
                selected: segment.value == selected,
                onTap: () => onChanged(segment.value),
              ),
            ),
        ],
      ),
    );
  }
}

final class _AdminSegmentButton<T> extends StatelessWidget {
  const _AdminSegmentButton({
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  final AdminSegment<T> segment;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = selected ? colorScheme.onPrimary : colorScheme.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      label: segment.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.small,
          ),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (segment.icon != null) ...[
                Icon(segment.icon, size: 16, color: foreground),
                const SizedBox(width: AppSpacing.xSmall),
              ],
              Flexible(
                child: Text(
                  segment.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Label, hint and control arranged responsively.
final class AdminPreferenceRow extends StatelessWidget {
  const AdminPreferenceRow({
    required this.label,
    required this.control,
    super.key,
    this.description,
    this.icon,
    this.controlWidth = 220,
  });

  final String label;
  final String? description;
  final IconData? icon;
  final Widget control;
  final double controlWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final labelBlock = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadii.medium),
            ),
            child: Icon(icon, size: 18, color: colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.medium),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textTheme.bodyMedium),
              if (description != null) ...[
                const SizedBox(height: 2),
                Text(
                  description!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 460) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              labelBlock,
              const SizedBox(height: AppSpacing.medium),
              control,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: labelBlock),
            const SizedBox(width: AppSpacing.large),
            SizedBox(width: controlWidth, child: control),
          ],
        );
      },
    );
  }
}

/// Theme and language pickers shared by the account dialog and settings page.
final class AdminThemeLanguageControls extends StatelessWidget {
  const AdminThemeLanguageControls({super.key, this.controlWidth = 220});

  final double controlWidth;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageCode = Localizations.localeOf(context).languageCode;

    return Column(
      children: [
        AdminPreferenceRow(
          icon: LucideIcons.sunMoon,
          label: l10n.appearance,
          controlWidth: controlWidth,
          control: AdminSegmentedControl<ThemeMode>(
            selected: isDark ? ThemeMode.dark : ThemeMode.light,
            onChanged: applyAdminThemeMode,
            segments: [
              AdminSegment(
                value: ThemeMode.light,
                label: l10n.themeLight,
                icon: LucideIcons.sun,
              ),
              AdminSegment(
                value: ThemeMode.dark,
                label: l10n.themeDark,
                icon: LucideIcons.moon,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        AdminPreferenceRow(
          icon: LucideIcons.languages,
          label: l10n.language,
          controlWidth: controlWidth,
          control: AdminSegmentedControl<String>(
            selected: languageCode == 'ar' ? 'ar' : 'en',
            onChanged: applyAdminLanguage,
            segments: [
              AdminSegment(value: 'en', label: l10n.english),
              AdminSegment(value: 'ar', label: l10n.arabic),
            ],
          ),
        ),
      ],
    );
  }
}

/// Applies a theme mode when the DI container is available.
///
/// Isolated widget tests build the shell without providers, so the tap becomes
/// a no-op instead of throwing.
void applyAdminThemeMode(ThemeMode mode) {
  if (!getIt.isRegistered<ThemeCubit>()) return;
  unawaited(getIt<ThemeCubit>().changeTheme(mode));
}

/// Applies a language code when the DI container is available.
void applyAdminLanguage(String languageCode) {
  if (!getIt.isRegistered<LocalizationCubit>()) return;
  unawaited(getIt<LocalizationCubit>().changeLanguage(languageCode));
}
