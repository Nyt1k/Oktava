import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';

Future<bool> showRemoveSongFromPlaylistDialog<bool>(BuildContext context, String name) {
  return showGenericDialog(
    context: context,
    title: 'Remove song',
    content: Text(
      'Are you sure you want to remove song: $name, from this playlist?',
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
