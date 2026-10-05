import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'outlined_button_component.dart';

@widgetbook.UseCase(name: 'Default', type: OutlinedButtonComponent)
Widget buildOutlinedButtonUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: OutlinedButtonComponent(
        label: context.knobs.string(label: 'Label', initialValue: 'Cancel'),
        onPressed: () {},
        isEnabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
        useInBorderRadius: context.knobs.boolean(label: 'Inner Border Radius'),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: OutlinedButtonComponent)
Widget buildOutlinedButtonDisabledUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: OutlinedButtonComponent(
        label: 'Disabled',
        onPressed: () {},
        isEnabled: false,
      ),
    ),
  );
}
