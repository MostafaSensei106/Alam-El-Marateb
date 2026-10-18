import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_config.dart';
import '../../di/di.dart';
import '../../services/theme/theme_service.dart';

extension BottomSheetExtension on BuildContext {
  // ignore: unused_element
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConfig.outBorderRadius.r),
        ),
      ),
      builder: (context) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(AppConfig.paddingHalf.h),
          child: child,
        ),
      ),
    );
  }
}
