import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Cupertino-styled dialogs shared by every app.
///
/// Button labels fall back to English — the app passes localized strings
/// (`cancelText`, `confirmText`, `okText`, `loadingText`). Navigation uses
/// plain `Navigator` so this package never depends on the app's router.
final class DialogComponent extends StatelessWidget {
  const DialogComponent({
    required this.title,
    required this.actions,
    this.content,
    this.icon,
    super.key,
  });

  final Widget title;
  final Widget? content;
  final List<Widget> actions;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }

  static Future<T?> showConfirmation<T>({
    required BuildContext context,
    required String title,
    required String body,
    required VoidCallback onConfirm,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
  }) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) => DialogComponent(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        content: Text(body, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          CupertinoDialogAction(
            onPressed: () async {
              await HapticFeedback.vibrate();
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(
              cancelText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await HapticFeedback.vibrate();
              if (context.mounted) Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(
              confirmText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showLoading(BuildContext context, {String loadingText = 'Please wait…'}) {
    unawaited(
      showCupertinoDialog(
        context: context,
        builder: (context) => PopScope(
          canPop: false,
          child: DialogComponent(
            title: Text(
              loadingText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: CupertinoActivityIndicator()),
            ),
            actions: const [],
          ),
        ),
      ),
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String error,
    String okText = 'OK',
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => DialogComponent(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        content: Text(error, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              await HapticFeedback.vibrate();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              okText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String body,
    String okText = 'OK',
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => DialogComponent(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        content: Text(body, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              await HapticFeedback.vibrate();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              okText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  static Future<T?> showCustom<T>({
    required BuildContext context,
    required Widget title,
    required List<Widget> actions,
    Widget? content,
    Widget? icon,
  }) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) =>
          DialogComponent(title: title, content: content, actions: actions),
    );
  }
}
