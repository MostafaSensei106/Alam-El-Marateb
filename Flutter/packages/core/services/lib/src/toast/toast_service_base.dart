import 'package:flutter/widgets.dart';

abstract interface class ToastServiceBase {
  void showSimple(BuildContext context, String message);
  void showError(BuildContext context, String message);
  void showSuccess(BuildContext context, String message);
  void showWarning(BuildContext context, String message);
  void showInfo(BuildContext context, String message);
}
