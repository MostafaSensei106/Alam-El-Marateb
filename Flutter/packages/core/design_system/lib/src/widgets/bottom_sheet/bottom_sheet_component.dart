import 'package:flutter/material.dart';

import '../../ds_config.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:core_utils/core_utils.dart';
import 'package:core_utils/core_utils.dart';

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
          top: Radius.circular(DsConfig.outBorderRadius.r),
        ),
      ),
      builder: (context) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(DsConfig.paddingHalf.h),
          child: child,
        ),
      ),
    );
  }
}
