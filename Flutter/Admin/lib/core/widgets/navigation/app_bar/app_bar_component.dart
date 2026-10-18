import 'package:flutter/material.dart';

/// A custom app bar widget with a transparent background and a centered title.
class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an [AppBarComponent].
  ///
  /// The [title] parameter is required.
  const AppBarComponent({
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    super.key,
  });

  /// The title to display in the app bar.
  final String title;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional list of action widgets.
  final List<Widget>? actions;

  /// Optional bottom widget.
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(title),

    leading: leading,
    actions: actions,
    bottom: bottom,
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Theme.of(context).colorScheme.surface,
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    actionsPadding: const EdgeInsets.all(4),
  );
}
