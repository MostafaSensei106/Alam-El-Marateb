import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'switch_component.dart';

@widgetbook.UseCase(name: 'Default', type: SwitchComponent)
Widget buildSwitchUseCase(BuildContext context) {
  return HookBuilder(
    builder: (context) {
      final enabled = useState(false);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SwitchComponent(
            label: context.knobs.string(
              label: 'Label',
              initialValue: 'Notifications',
            ),
            value: enabled.value,
            onChanged: (v) => enabled.value = v,
          ),
        ),
      );
    },
  );
}
