import 'package:flutter/material.dart';

import '../../constants/app_config.dart';
import '../../di/di.dart';
import '../../services/theme/theme_service.dart';

extension BottomSheetExtension on BuildContext {
  Future<void> showBottomSheetComponent({
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      context: this,
      showDragHandle: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: getIt<ThemeService>().get(this).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConfig.outBorderRadius),
        ),
      ),
      builder: (context) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(AppConfig.paddingHalf),
          child: child,
        ),
      ),
    );
  }
}
