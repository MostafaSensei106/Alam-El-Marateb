import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'retryable_error_state_widget.dart';

@widgetbook.UseCase(name: 'Default', type: RetryableErrorStateWidget)
Widget buildRetryableErrorStateUseCase(BuildContext context) {
  return SizedBox(
    height: 400,
    child: RetryableErrorStateWidget(
      message: context.knobs.string(
        label: 'Message',
        initialValue: 'Failed to load data',
      ),
      title: context.knobs.string(label: 'Title', initialValue: 'Error'),
      retryButtonText: context.knobs.string(
        label: 'Retry Text',
        initialValue: 'Retry',
      ),
      onRetry: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Server Error', type: RetryableErrorStateWidget)
Widget buildRetryableErrorServerUseCase(BuildContext context) {
  return SizedBox(
    height: 400,
    child: RetryableErrorStateWidget(
      message: 'Internal server error. Our team has been notified.',
      title: 'Server Error',
      icon: Icons.cloud_off,
      onRetry: () {},
    ),
  );
}
