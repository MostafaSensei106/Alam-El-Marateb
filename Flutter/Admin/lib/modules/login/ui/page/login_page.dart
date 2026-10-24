import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../logic/cubit/login_cubit.dart';
import '../../logic/cubit/login_state.dart';
import '../widgets/login_form_panel.dart';
import '../widgets/login_image_panel.dart';
import '../widgets/login_language_button.dart';

/// Admin sign-in screen.
///
/// Wide windows place the form beside the image; narrow windows stack the
/// image above the form. The language switch floats over both layouts.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const double _wideBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;

    return Scaffold(
      body: BlocSignalListener<LoginCubit, LoginState>(
        listener: (BuildContext context, state) {
          state.whenOrNull(
            loading: (_) => context.dialog.showLoading(),
            success: (_, user) {
              context.pop();
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (isWide)
                const Row(
                  children: [
                    Expanded(child: LoginFormPanel()),
                    Expanded(child: LoginImagePanel()),
                  ],
                )
              else
                const Column(
                  children: [
                    Expanded(flex: 3, child: LoginImagePanel()),
                    Expanded(flex: 2, child: LoginFormPanel()),
                  ],
                ),
              Positioned(
                top: MediaQuery.paddingOf(context).top,
                left: 0,
                right: 0,
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.small),
                  child: LoginLanguageButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
