import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'empty_state_widget.dart';

@widgetbook.UseCase(name: 'Default', type: EmptyStateWidget)
Widget buildEmptyStateUseCase(BuildContext context) {
  return SizedBox(
    height: 400,
    child: EmptyStateWidget(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'No items found',
      ),
      subtitle: context.knobs.string(
        label: 'Subtitle',
        initialValue: 'Try adjusting your filters',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Without Subtitle', type: EmptyStateWidget)
Widget buildEmptyStateNoSubtitleUseCase(BuildContext context) {
  return SizedBox(
    height: 400,
    child: EmptyStateWidget(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Your cart is empty',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Long Text Overflow', type: EmptyStateWidget)
Widget buildEmptyStateLongTextUseCase(BuildContext context) {
  return const SizedBox(
    height: 400,
    child: EmptyStateWidget(
      title: 'This is a really long title that should wrap properly across multiple lines to test text overflow behavior',
      subtitle: 'And this is an equally long subtitle text to ensure the layout handles long content gracefully without any issues',
    ),
  );
}
