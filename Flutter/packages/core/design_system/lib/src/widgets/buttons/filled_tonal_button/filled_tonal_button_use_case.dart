import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'filled_tonal_button_component.dart';

@widgetbook.UseCase(name: 'Default', type: FilledTonalButtonComponent)
Widget buildFilledTonalButtonUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: FilledTonalButtonComponent(
        label: context.knobs.string(label: 'Label', initialValue: 'Tonal'),
        onPressed: () {},
        useInBorderRadius: context.knobs.boolean(label: 'Inner Border Radius'),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With Icon', type: FilledTonalButtonComponent)
Widget buildFilledTonalButtonIconUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: FilledTonalButtonComponent.icon(
        label: context.knobs.string(label: 'Label', initialValue: 'Filter'),
        icon: Icons.filter_list,
        onPressed: () {},
      ),
    ),
  );
}
