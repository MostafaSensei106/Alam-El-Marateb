import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/extensions/extensions.dart';
import 'package:alam_el_marateb_constants/constants.dart';

class OtpFieldComponent extends StatelessWidget {
  const OtpFieldComponent({
    required this.onCompleted,
    this.onChanged,
    super.key,
    this.length = 6,
  });

  final int length;
  final void Function(String) onCompleted;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: UiMetrics.otpFieldSize.w,
      height: UiMetrics.otpFieldSize.w,
      textStyle: Theme.of(context).textTheme.titleLarge,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(ApplicationRadius.outerBorderRadius.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Colors.green.withValues(alpha: 0.08),
      border: Border.all(color: Colors.green, width: 1.5),
    );

    return Pinput(
      length: length,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      onCompleted: onCompleted,
      onChanged: onChanged,
      separatorBuilder: (index) => SizedBox(width: ApplicationPadding.paddingHalf.w),
    );
  }
}
