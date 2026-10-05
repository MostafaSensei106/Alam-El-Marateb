import 'package:flutter/material.dart';

final class LoadingIndicatorComponent extends StatelessWidget {
  const LoadingIndicatorComponent({super.key, this.value});
  final double? value;

  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      value: value,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}
