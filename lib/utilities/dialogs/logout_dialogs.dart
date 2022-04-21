import 'package:flutter/cupertino.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog<bool>(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to logout?',
    optionBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
