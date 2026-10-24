import 'package:flutter/material.dart';

import 'login_form_panel.dart';
import 'login_image_panel.dart';

/// Login composition for compact windows.
///
/// The image keeps the larger share of the height so the form stays reachable
/// without shrinking the welcoming visual.
final class LoginCompactLayout extends StatelessWidget {
  const LoginCompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(flex: 3, child: LoginImagePanel()),
        Expanded(flex: 2, child: LoginFormPanel()),
      ],
    );
  }
}
