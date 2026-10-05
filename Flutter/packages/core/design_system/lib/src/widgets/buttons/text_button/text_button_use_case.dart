import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'text_button_component.dart';

@widgetbook.UseCase(name: 'Default', type: TextButtonComponent)
Widget buildTextButtonUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: TextButtonComponent(
        label: context.knobs.string(label: 'Label', initialValue: 'Learn More'),
        onPressed: () {},
        isEnable: context.knobs.boolean(label: 'Enabled', initialValue: true),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With Icon', type: TextButtonComponent)
Widget buildTextButtonIconUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: TextButtonComponent.icon(
        label: context.knobs.string(label: 'Label', initialValue: 'Retry'),
        icon: Icons.refresh,
        onPressed: () {},
      ),
    ),
  );
}
