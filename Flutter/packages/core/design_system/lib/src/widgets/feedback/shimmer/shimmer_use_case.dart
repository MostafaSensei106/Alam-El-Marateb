import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'shimmer_component.dart';

@widgetbook.UseCase(name: 'Default', type: ShimmerComponent)
Widget buildShimmerUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: ShimmerComponent(
        enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(width: 200, height: 16, color: Colors.grey[300]),
          ],
        ),
      ),
    ),
  );
}
