import 'package:flutter/material.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';

String? playlistId;

Future<String?> showAddSongToPlaylistDialog(
  BuildContext context,
  AuthUser user,
) {
  return showGenericDialog(
      context: context,
      title: 'Pick playlist',
      content: playlistSelector(user),
      optionBuilder: () => {}).then((value) => playlistId!);
}

Widget playlistSelector(AuthUser user) {
  playlistId = 'non';
  return SizedBox(
    height: 300,
    width: 300,
    child: ListView.builder(
        itemCount: user.userPlaylists!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 80,
              child: Ink(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        user.userPlaylists![index]!.id,
                        style: const TextStyle(
                            color: secondaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        playlistId = user.userPlaylists![index]!.id;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
  );
}
