import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'elevated_button_component.dart';

@widgetbook.UseCase(name: 'Default', type: ElevatedButtonComponent)
Widget buildElevatedButtonUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButtonComponent(
        label: context.knobs.string(label: 'Label', initialValue: 'Elevated'),
        onPressed: () {},
        useInBorderRadius: context.knobs.boolean(label: 'Inner Border Radius'),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With Icon', type: ElevatedButtonComponent)
Widget buildElevatedButtonIconUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButtonComponent.icon(
        label: context.knobs.string(label: 'Label', initialValue: 'Add Item'),
        icon: Icons.add,
        onPressed: () {},
      ),
    ),
  );
}
