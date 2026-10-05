import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'error_state_widget.dart';

@widgetbook.UseCase(name: 'Default', type: ErrorStateWidget)
Widget buildErrorStateUseCase(BuildContext context) {
  return SizedBox(
    height: 400,
    child: ErrorStateWidget(
      message: context.knobs.string(
        label: 'Message',
        initialValue: 'Something went wrong. Please try again.',
      ),
      title: context.knobs.string(label: 'Title', initialValue: 'Error'),
    ),
  );
}

@widgetbook.UseCase(name: 'Network Error', type: ErrorStateWidget)
Widget buildErrorStateNetworkUseCase(BuildContext context) {
  return const SizedBox(
    height: 400,
    child: ErrorStateWidget(
      message: 'No internet connection. Please check your network settings.',
      title: 'Connection Error',
      icon: Icons.wifi_off,
    ),
  );
}
