import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/services/auth/auth_exception.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/services/auth/bloc/auth_state.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/app_icon_widget.dart';

import '../../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundException) {
            await showErrorDialog(context, 'User is not found');
          } else if (state.exception is WrongPasswordException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Login',
            style: TextStyle(color: additionalColor),
          ),
          backgroundColor: additionalColor,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: const Icon(
                Icons.exit_to_app_rounded,
                size: 32,
              ),
            ),
            splashRadius: 15,
            hoverColor: mainColor,
            splashColor: mainColor,
            color: mainColor,
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.question_mark_rounded,
                size: 32,
              ),
              splashRadius: 15,
              hoverColor: mainColor,
              splashColor: mainColor,
              color: mainColor,
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationVersion: 'version: 1.0.1',
                    applicationName: 'Oktava',
                    applicationIcon: appIcon(),
                    applicationLegalese:
                        'Oktava is music streaming platform, where people can publish there song and others can listen them.');
              },
            )
          ],
        ),
        backgroundColor: additionalColor,
        body: ListView(physics: const BouncingScrollPhysics(), children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 200, child: Image.asset("assets/images/logo.png")),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _email,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    disabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: additionalColor, width: 2.0),
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
                  style: const TextStyle(color: mainColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    disabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: additionalColor, width: 2.0),
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
                  style: const TextStyle(color: mainColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => mainColor)),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                          AuthEventLogIn(
                            email,
                            password,
                          ),
                        );
                  },
                  child:
                      const Text('Login', style: TextStyle(color: mainColor)),
                ),
                TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => mainColor)),
                  onPressed: () async {
                    context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                  },
                  child: const Text('Forgot password?',
                      style: TextStyle(color: mainColor)),
                ),
                TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => mainColor)),
                  onPressed: () async {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                  child: const Text('Register here',
                      style: TextStyle(color: mainColor)),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
