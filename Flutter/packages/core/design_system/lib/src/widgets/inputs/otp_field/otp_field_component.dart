import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import 'package:core_utils/src/extensions/extensions.dart';

import '../../../ds_config.dart';

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
      width: DsConfig.otpFieldSize.w,
      height: DsConfig.otpFieldSize.w,
      textStyle: context.textTheme.titleLarge,
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.outline),
        borderRadius: BorderRadius.circular(DsConfig.outBorderRadius.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: context.colorScheme.primary, width: 2),
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
      separatorBuilder: (index) => SizedBox(width: DsConfig.paddingHalf.w),
    );
  }
}
