import 'package:flutter/material.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog<bool>(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: const Text('Are you sure you want to logout?'),
    optionBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
