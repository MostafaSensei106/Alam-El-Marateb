import 'package:flutter/material.dart';

import '../widgets/feedback/dialog/dialog_component.dart';

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

  /// Safely dismisses the currently presented dialog.
  ///
  /// Uses [Navigator.canPop] to ensure we do not accidentally pop the base
  /// screen route if the dialog was already closed.
  void dismiss() {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
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
