import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Verify email',
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
              "We've sent you an email verification. Please open it to verify your account.",
              style: TextStyle(color: mainColor),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "If you haven`t received a verification email yet, press a button below",
              style: TextStyle(color: mainColor),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateColor.resolveWith((states) => mainColor)),
              onPressed: () {
                context
                    .read<AuthBloc>()
                    .add(const AuthEventSendEmailVerification());
              },
              child: const Text('Send email verification ',
                  style: TextStyle(color: mainColor)),
            ),
            TextButton(
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateColor.resolveWith((states) => mainColor)),
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('Restart', style: TextStyle(color: mainColor)),
            )
          ],
        ),
      ),
    );
  }
}
