/// Compact form building blocks reused by every accounting form.
///
/// The backend payloads are short (a handful of scalars plus journal lines),
/// so the forms render inside the same tab as a single card instead of a
/// dialog. Fields flow in one column on narrow screens and two columns on
/// wide ones; wrap a child in [AccountingFormWide] to keep it full width.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../../core/widgets/inputs/dropdown/dropdown_button_form_field_component.dart';
import '../../../../../core/widgets/inputs/text_form_field/text_form_field_component.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';

/// Marks a [AccountingFormCard] child that must span the full row.
final class AccountingFormWide extends StatelessWidget {
  const AccountingFormWide({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Card that lays form fields out in a responsive one/two column grid.
final class AccountingFormCard extends StatelessWidget {
  const AccountingFormCard({
    required this.title,
    required this.fields,
    super.key,
    this.subtitle,
    this.icon,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> fields;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeading(title: title, subtitle: subtitle, icon: icon),
          const SizedBox(height: AppSpacing.large),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = AppSpacing.medium;
              final twoColumns = constraints.maxWidth >= 560;
              final fieldWidth = twoColumns
                  ? (constraints.maxWidth - spacing) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: spacing,
                runSpacing: AppSpacing.medium,
                children: [
                  for (final child in fields)
                    SizedBox(
                      width: child is AccountingFormWide
                          ? constraints.maxWidth
                          : fieldWidth,
                      child: child,
                    ),
                ],
              );
            },
          ),
          if (actions != null) ...[
            const SizedBox(height: AppSpacing.xLarge),
            actions!,
          ],
        ],
      ),
    );
  }
}

/// Thin wrapper over [TextFormFieldComponent] with the accounting defaults.
final class AccountingTextField extends StatelessWidget {
  const AccountingTextField({
    required this.label,
    required this.icon,
    super.key,
    this.controller,
    this.initialValue,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.errorText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? errorText;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextFormFieldComponent(
    label: label,
    prefixIcon: icon,
    controller: controller,
    initialValue: initialValue,
    hintText: hint,
    keyboardType: keyboardType,
    maxLines: maxLines,
    errorText: errorText,
    readOnly: readOnly,
    onTap: onTap,
    onChanged: onChanged,
  );
}

/// Thin wrapper over [DropdownButtonFormFieldComponent] for enum pickers.
final class AccountingDropdownField<T> extends StatelessWidget {
  const AccountingDropdownField({
    required this.label,
    required this.icon,
    required this.options,
    required this.onChanged,
    super.key,
    this.initialValue,
    this.hint,
  });

  final String label;
  final IconData icon;
  final List<(T, String)> options;
  final ValueChanged<T?> onChanged;
  final T? initialValue;
  final String? hint;

  @override
  Widget build(BuildContext context) => DropdownButtonFormFieldComponent<T>(
    label: label,
    prefixIcon: icon,
    hintText: hint,
    initialValue: initialValue,
    items: [
      for (final (value, text) in options)
        DropdownMenuItem<T>(value: value, child: Text(text)),
    ],
    onChanged: onChanged,
  );
}

/// Save/discard row shared by the create and edit forms.
final class AccountingFormActions extends StatelessWidget {
  const AccountingFormActions({
    required this.onSave,
    required this.onCancel,
    super.key,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.small,
      children: [
        FilledButton.icon(
          onPressed: onSave,
          icon: const Icon(LucideIcons.check, size: AppIconSizes.small),
          label: Text(l10n.accountingSave),
        ),
        OutlinedButton.icon(
          onPressed: onCancel,
          icon: const Icon(LucideIcons.x, size: AppIconSizes.small),
          label: Text(l10n.cancel),
        ),
      ],
    );
  }
}
