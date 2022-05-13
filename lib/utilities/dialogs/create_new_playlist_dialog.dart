import 'package:flutter/material.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/error_dialog.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';
import 'package:oktava/utilities/dialogs/loading_dialog.dart';

TextEditingController playlistName = TextEditingController();

Future<void> showCreateNewPlaylistDialog(
    BuildContext context, AuthUser user) async {
  return showGenericDialog(
      context: context,
      title: 'Create new playlist',
      content: createNewPlaylist(context, user),
      optionBuilder: () => {});
}

Widget createNewPlaylist(BuildContext context, AuthUser user) {
  playlistName.text = '';
  return SizedBox(
    height: 130,
    width: 350,
    child: Column(
      children: [
        TextField(
          controller: playlistName,
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2.0),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2.0),
            ),
            hintText: 'Enter playlist name',
            hintStyle: TextStyle(color: mainColor.withAlpha(120)),
          ),
          style: const TextStyle(color: mainColor),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: mainColor,
          ),
          onPressed: () async {
            if (playlistName.text.isNotEmpty) {
              showLoadingDialog(context, 'Creating playlist');
              await FirebaseAuthProvider()
                  .savePlaylist(user.id, playlistName.text);
              Navigator.pop(context);
            } else {
              await showErrorDialog(context, 'Enter playlist name');
            }
            Navigator.pop(context);
          },
          child: const Text(
            'Upload song',
            style: TextStyle(color: additionalColor),
          ),
        )
      ],
    ),
  );
}
