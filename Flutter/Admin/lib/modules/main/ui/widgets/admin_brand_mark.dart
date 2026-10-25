import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Rounded store badge that identifies the admin workspace.
///
/// Shared by the navigation rail and the compact-width drawer so both chromes
/// stay visually identical.
final class AdminBrandMark extends StatelessWidget {
  const AdminBrandMark({this.iconSize = 22, super.key});

  /// Size of the store glyph inside the badge.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Icon(
          LucideIcons.store,
          size: iconSize,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
