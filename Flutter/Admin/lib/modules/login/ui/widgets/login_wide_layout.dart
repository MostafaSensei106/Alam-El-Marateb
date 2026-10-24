import 'package:flutter/material.dart';

import 'login_form_panel.dart';
import 'login_image_panel.dart';

/// Login composition for wide windows.
///
/// The form and the decorative image share the screen side by side.
final class LoginWideLayout extends StatelessWidget {
  const LoginWideLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: LoginFormPanel()),
        Expanded(child: LoginImagePanel()),
      ],
    );
  }
}
