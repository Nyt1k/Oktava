import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSendDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password reset',
    content: const Text(
      'Now we sent you a password reset link on email',
      style: TextStyle(
        color: mainColor,
      ),
    ),
    optionBuilder: () => {
      'OK': null,
    },
  );
}
