import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'loading_indicator_component.dart';

@widgetbook.UseCase(name: 'Indeterminate', type: LoadingIndicatorComponent)
Widget buildLoadingIndicatorUseCase(BuildContext context) {
  return const Center(child: LoadingIndicatorComponent());
}

@widgetbook.UseCase(name: 'Determinate', type: LoadingIndicatorComponent)
Widget buildLoadingIndicatorDeterminateUseCase(BuildContext context) {
  return Center(
    child: LoadingIndicatorComponent(
      value: context.knobs.double.slider(
        label: 'Progress',
        initialValue: 0.6,
        max: 1,
      ),
    ),
  );
}
