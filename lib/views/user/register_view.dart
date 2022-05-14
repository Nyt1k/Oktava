import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/services/auth/auth_exception.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/error_dialog.dart';

import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _userName;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _userName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _userName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeekPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email address');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Register',
            style: TextStyle(color: additionalColor),
          ),
          backgroundColor: mainColor,
        ),
        backgroundColor: additionalColor,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Center(
                      child: Text(
                    'Enter your account information to register.',
                    style: TextStyle(color: mainColor),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _userName,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: const TextStyle(color: mainColor),
                    decoration: InputDecoration(
                      hintText: 'User Name',
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _email,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: mainColor),
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: const TextStyle(color: mainColor),
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => mainColor)),
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            final userName = _userName.text;
                            context.read<AuthBloc>().add(AuthEventRegister(
                                  email,
                                  password,
                                  userName,
                                ));
                          },
                          child: const Text('Register',
                              style: TextStyle(color: mainColor)),
                        ),
                        TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => mainColor)),
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogOut(),
                                );
                          },
                          child: const Text('Back to login',
                              style: TextStyle(color: mainColor)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
