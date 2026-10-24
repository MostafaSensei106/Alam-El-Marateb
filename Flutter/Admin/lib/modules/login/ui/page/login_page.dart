import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart' show KaiselRouterContextX;

import '../../../../core/extensions/extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../logic/cubit/login_cubit.dart';
import '../../logic/cubit/login_state.dart';
import '../widgets/login_compact_layout.dart';
import '../widgets/login_language_button.dart';
import '../widgets/login_wide_layout.dart';

/// Admin sign-in screen.
///
/// Wide windows place the form beside the image; compact windows use a
/// full-bleed photographic header with the form in a rounded sheet, and move
/// the language switch to a floating icon at the bottom.
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
            success: (_, _) async {
              Navigator.of(context).pop();
              context.toast.showSuccess(context, context.localeKeys.welcome);
              await context.router<AppRoute>().replaceTop(
                const MainRouteEntry(),
              );
            },

            failure: (_, e) async {
              Navigator.of(context).pop();
              await context.dialog.showError(
                title: context.localeKeys.error,
                error: e,
              );
            },
          );
        },
        child: isWide ? const _WideBody() : const LoginCompactLayout(),
      ),
    );
  }
}

/// Wide composition: padded split layout with the text language switch on top.
final class _WideBody extends StatelessWidget {
  const _WideBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const LoginWideLayout(),
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
    );
  }
}
