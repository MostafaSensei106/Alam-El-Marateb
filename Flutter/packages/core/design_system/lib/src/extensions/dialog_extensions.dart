import 'package:flutter/material.dart';

import '../widgets/feedback/dialog/dialog_component.dart';

/// Dialog shortcuts on BuildContext (lives here to avoid a
/// core_utils -> design_system dependency cycle).
extension DialogExtensions on BuildContext {
  DialogProxy get dialog => DialogProxy(this);
}

class DialogProxy {
  DialogProxy(this.context);
  final BuildContext context;

  Future<T?> showDialog<T>({
    required Widget title,
    required List<Widget> actions,
    Widget? content,
    Widget? icon,
  }) {
    return DialogComponent.showCustom<T>(
      context: context,
      title: title,
      content: content,
      actions: actions,
      icon: icon,
    );
  }

  Future<T?> showConfirmation<T>({
    required String title,
    required String body,
    required VoidCallback onConfirm,
  }) {
    return DialogComponent.showConfirmation<T>(
      context: context,
      title: title,
      body: body,
      onConfirm: onConfirm,
    );
  }

  void showLoading() {
    DialogComponent.showLoading(context);
  }

  void dismiss() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> showInfo({required String title, required String body}) {
    return DialogComponent.showInfo(context: context, title: title, body: body);
  }

  Future<void> showError({required String title, required String error}) {
    return DialogComponent.showError(
      context: context,
      title: title,
      error: error,
    );
  }
}
