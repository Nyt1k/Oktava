import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteSongDialog<bool>(BuildContext context, String name) {
  return showGenericDialog(
    context: context,
    title: 'Delete song',
    content: Text(
      'Are you sure you want to delete song: $name',
      style: const TextStyle(
        color: mainColor,
      ),
    ),
    optionBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then((value) => value ?? false);
}
