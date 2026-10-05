import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../ds_config.dart';

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
    final colorScheme = getIt<ThemeService>().get(context);

    return SearchBar(
      controller: controller,
      leading: const Icon(Iconsax.search_normal_1_copy),
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
          borderRadius: BorderRadius.circular(DsConfig.outBorderRadius),
        ),
      ),
      keyboardType: TextInputType.name,
    );
  }
}
