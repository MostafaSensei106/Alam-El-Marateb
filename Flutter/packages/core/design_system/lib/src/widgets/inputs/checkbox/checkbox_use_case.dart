import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'checkbox_component.dart';

@widgetbook.UseCase(name: 'Default', type: CheckboxComponent)
Widget buildCheckboxUseCase(BuildContext context) {
  return HookBuilder(
    builder: (context) {
      final checked = useState(false);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CheckboxComponent(
            title: context.knobs.string(
              label: 'Title',
              initialValue: 'Accept Terms',
            ),
            value: checked.value,
            onChanged: (v) => checked.value = v ?? false,
          ),
        ),
      );
    },
  );
}
