import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'filled_button_component.dart';

@widgetbook.UseCase(name: 'Default', type: FilledButtonComponent)
Widget buildFilledButtonUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: FilledButtonComponent(
        label: context.knobs.string(label: 'Label', initialValue: 'Submit'),
        onPressed: () {},
        isEnabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
        useInBorderRadius: context.knobs.boolean(label: 'Inner Border Radius'),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: FilledButtonComponent)
Widget buildFilledButtonDisabledUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: FilledButtonComponent(
        label: 'Disabled',
        onPressed: () {},
        isEnabled: false,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With Icon', type: FilledButtonComponent)
Widget buildFilledButtonIconUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: FilledButtonComponent.icon(
        label: context.knobs.string(label: 'Label', initialValue: 'Save'),
        icon: Icons.save,
        onPressed: () {},
        isEnabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
      ),
    ),
  );
}
