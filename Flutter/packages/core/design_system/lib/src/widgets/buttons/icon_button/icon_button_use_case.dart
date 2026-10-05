import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'icon_button_component.dart';

@widgetbook.UseCase(name: 'Standard', type: IconButtonComponent)
Widget buildIconButtonStandardUseCase(BuildContext context) {
  return Center(
    child: IconButtonComponent(icon: Icons.favorite, onPressed: () {}),
  );
}

@widgetbook.UseCase(name: 'Filled', type: IconButtonComponent)
Widget buildIconButtonFilledUseCase(BuildContext context) {
  return Center(
    child: IconButtonComponent.filled(
      icon: Icons.add,
      onPressed: () {},
      useInBorderRadius: context.knobs.boolean(label: 'Inner Border Radius'),
    ),
  );
}

@widgetbook.UseCase(name: 'Tonal', type: IconButtonComponent)
Widget buildIconButtonTonalUseCase(BuildContext context) {
  return Center(
    child: IconButtonComponent.tonal(icon: Icons.edit, onPressed: () {}),
  );
}

@widgetbook.UseCase(name: 'Outlined', type: IconButtonComponent)
Widget buildIconButtonOutlinedUseCase(BuildContext context) {
  return Center(
    child: IconButtonComponent.outlined(icon: Icons.share, onPressed: () {}),
  );
}
