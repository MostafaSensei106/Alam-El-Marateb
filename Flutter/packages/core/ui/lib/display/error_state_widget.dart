import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:alam_el_marateb_constants/constants.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.message,
    this.title,
    this.icon = Iconsax.warning_2_copy,
    super.key,
  });

  final String message;
  final String? title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: ApplicationPadding.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 60.sp, color: color.error),
              SizedBox(height: 16.h),
            ],
            Text(
              // English fallback — the app passes the localized title.
              title ?? 'Error',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
