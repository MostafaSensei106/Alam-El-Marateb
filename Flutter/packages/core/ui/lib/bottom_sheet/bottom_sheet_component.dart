import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alam_el_marateb_constants/constants.dart';

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
      backgroundColor: Theme.of(this).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ApplicationRadius.outerBorderRadius.r),
        ),
      ),
      builder: (context) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(ApplicationPadding.paddingHalf.h),
          child: child,
        ),
      ),
    );
  }
}
