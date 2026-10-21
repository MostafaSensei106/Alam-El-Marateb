import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/app_config.dart';

final class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({
    required this.controller,
    required this.hintText,
    super.key,
    this.onChanged,
    this.onTap,
    this.isEnabled = true,
    this.trailing,
  });
  final TextEditingController controller;
  final String hintText;
  final bool isEnabled;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final Iterable<Widget>? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SearchBar(
      controller: controller,
      leading: const Icon(LucideIcons.search),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onTap: onTap,
      enabled: isEnabled,
      hintText: hintText,
      onChanged: onChanged,
      elevation: const WidgetStatePropertyAll(0),
      trailing: trailing,

      backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainer),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
        ),
      ),
      keyboardType: TextInputType.name,
    );
  }
}
