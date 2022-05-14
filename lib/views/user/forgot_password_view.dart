import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/services/auth/bloc/auth_state.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/error_dialog.dart';
import 'package:oktava/utilities/dialogs/password_reset_email_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSendEmail) {
            _controller.clear();
            await showPasswordResetSendDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                'We could`n process your request, please try again or create new user account');
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Restore password',
            style: TextStyle(color: additionalColor),
          ),
          backgroundColor: mainColor,
        ),
        backgroundColor: additionalColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                  'Enter you email and we will send you password reset mail.',
                  style: TextStyle(color: mainColor)),
              const SizedBox(
                height: 30,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: _controller,
                style: const TextStyle(color: mainColor),
                decoration: InputDecoration(
                  hintText: 'Your email address...',
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: additionalColor, width: 2.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateColor.resolveWith((states) => mainColor)),
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                child: const Text('Send me password',
                    style: TextStyle(color: mainColor)),
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateColor.resolveWith((states) => mainColor)),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Back to login page',
                    style: TextStyle(color: mainColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
