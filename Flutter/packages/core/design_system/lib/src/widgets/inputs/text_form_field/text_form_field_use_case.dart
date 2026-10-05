import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'text_form_field_component.dart';

@widgetbook.UseCase(name: 'Default', type: TextFormFieldComponent)
Widget buildTextFormFieldUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormFieldComponent(
        label: context.knobs.string(label: 'Label', initialValue: 'Email'),
        hintText: context.knobs.string(
          label: 'Hint',
          initialValue: 'Enter email',
        ),
        isEnable: context.knobs.boolean(label: 'Enabled', initialValue: true),
        readOnly: context.knobs.boolean(label: 'Read Only'),
        obscureText: context.knobs.boolean(label: 'Obscure Text'),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With Error', type: TextFormFieldComponent)
Widget buildTextFormFieldErrorUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormFieldComponent(
        label: 'Email',
        hintText: 'Enter email',
        errorText: context.knobs.string(
          label: 'Error Text',
          initialValue: 'Invalid email address',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With Prefix Icon', type: TextFormFieldComponent)
Widget buildTextFormFieldPrefixUseCase(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: TextFormFieldComponent(
        label: 'Search',
        prefixIcon: Icons.search,
        hintText: 'Search...',
      ),
    ),
  );
}
