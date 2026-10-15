import 'package:alam_el_marateb_constants/constants.dart';
import 'package:alam_el_marateb_ui/ui.dart';
import 'package:alam_el_marateb_validators/validators.dart';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alam_el_marateb_auth/src/presentation/cubit/auth_cubit.dart';

/// Shared login screen used by all three apps.
///
/// Validation runs on shared formz inputs; error labels fall back to
/// English (`defaultMessage`) until the app wires its l10n to the stable
/// `messageId`s. On success the screen calls [onAuthenticated] — navigation
/// itself stays app-owned (the app router's redirect also reacts to the
/// auth notifier, so this is belt and suspenders).
final class LoginPage extends StatefulWidget {
  const LoginPage({required this.onAuthenticated, super.key});

  final VoidCallback onAuthenticated;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _password = TextEditingController();

  String? _phoneError;
  String? _passwordError;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final phoneInput = LoginPhoneValidator.dirty(_phone.text.trim());
    final passwordInput = LoginPasswordValidator.dirty(_password.text);
    setState(() {
      _phoneError = phoneInput.error?.defaultMessage;
      _passwordError = passwordInput.error?.defaultMessage;
    });
    if (!phoneInput.isValid || !passwordInput.isValid) return;
    context.read<AuthCubit>().signIn(
      phone: phoneInput.value,
      password: passwordInput.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(title: 'Sign in'),
      body: BlocSignalConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (_) => widget.onAuthenticated(),
            orElse: () {},
          );
        },
        builder: (context, state) {
          final submitting = state.maybeWhen(
            submitting: () => true,
            orElse: () => false,
          );
          return SingleChildScrollView(
            padding: EdgeInsets.all(ApplicationPadding.padding.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormFieldComponent(
                  label: 'Phone number',
                  hintText: '01xxxxxxxxx',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  errorText: _phoneError,
                  isEnable: !submitting,
                ),
                SizedBox(height: 12.h),
                PasswordFieldComponent(
                  label: 'Password',
                  controller: _password,
                  errorText: _passwordError,
                  isEnable: !submitting,
                ),
                SizedBox(height: 8.h),
                ...[
                  state.maybeWhen(
                    failed: (message) => Text(
                      message,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
                SizedBox(height: 16.h),
                FilledButtonComponent(
                  label: submitting ? 'Please wait…' : 'Sign in',
                  onPressed: submitting ? () {} : () => _submit(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
