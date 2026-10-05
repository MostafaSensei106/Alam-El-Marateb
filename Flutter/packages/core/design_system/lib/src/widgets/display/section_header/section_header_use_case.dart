import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'section_header_component.dart';

@widgetbook.UseCase(name: 'Default', type: SectionHeaderComponent)
Widget buildSectionHeaderUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SectionHeaderComponent(
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'Featured Products',
        ),
        actionLabel: context.knobs.string(
          label: 'Action Label',
          initialValue: 'View All',
        ),
        onActionPressed:
            context.knobs.boolean(label: 'Show Action', initialValue: true)
            ? () {}
            : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Without Action', type: SectionHeaderComponent)
Widget buildSectionHeaderNoActionUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SectionHeaderComponent(
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'Recent Orders',
        ),
      ),
    ),
  );
}
