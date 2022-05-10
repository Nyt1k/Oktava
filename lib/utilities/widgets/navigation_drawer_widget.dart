import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/repository/user_profile_image_factory.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/auth/auth_service.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/services/storage/storage_audio_player_factory.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/logout_dialogs.dart';
import 'package:oktava/views/additional/user_songs_view.dart';
import 'package:oktava/views/album/albums_view.dart';
import 'package:oktava/views/artist/artists_view.dart';
import 'package:oktava/views/additional/upload_song_view.dart';
import 'package:oktava/views/additional/user_profile_view.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final AuthUser user;
  const NavigationDrawerWidget({Key? key, required this.user})
      : super(
          key: key,
        );

  String get userId => AuthService.firebase().currentUser!.id;
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: Material(
          color: mainColor,
          child: ListView(
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              buildHeader(
                user: user,
                onTap: () => selectedItem(context, 0, user),
              ),
              Container(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    buildMenuItem(
                      text: 'All songs',
                      icon: Icons.music_note_outlined,
                      onClicked: () => selectedItem(context, 1, null),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    buildMenuItem(
                        text: 'Albums',
                        icon: Icons.album_rounded,
                        onClicked: () => selectedItem(context, 2, null)),
                    const SizedBox(
                      height: 8,
                    ),
                    buildMenuItem(
                      text: 'Artists',
                      icon: Icons.people_outline_rounded,
                      onClicked: () => selectedItem(context, 3, null),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    buildMenuItem(
                      text: 'Favorites',
                      icon: Icons.favorite_rounded,
                      onClicked: () => selectedItem(context, 4, null),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    buildMenuItem(
                      text: 'Playlists',
                      icon: Icons.playlist_play_rounded,
                      onClicked: () => selectedItem(context, 5, null),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                        height: 2,
                        decoration: const BoxDecoration(
                            color: additionalColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    const SizedBox(
                      height: 8,
                    ),
                    buildMenuItem(
                      text: 'My songs',
                      icon: Icons.library_music_rounded,
                      onClicked: () => selectedItem(context, 6, user),
                    ),
                    buildMenuItem(
                      text: 'Upload',
                      icon: Icons.cloud_upload_rounded,
                      onClicked: () => selectedItem(context, 7, null),
                    ),
                    buildMenuItem(
                      text: 'Settings',
                      icon: Icons.settings,
                      onClicked: () => selectedItem(context, 8, null),
                    ),
                    buildMenuItem(
                      text: 'Log out',
                      icon: Icons.logout_rounded,
                      onClicked: () async {
                        final shouldLogOut = await showLogOutDialog(context);

                        if (shouldLogOut) {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  selectedItem(BuildContext context, int index, AuthUser? user) async {
    switch (index) {
      case 0:
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserProfileView(
            user: user!,
          ),
        ));
        break;
      case 1:
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
        break;
      case 2:
        final list = await StorageAudioPlayerFactory().getModelsFromStorage();
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AlbumsView(
            models: list,
          ),
        ));
        break;
      case 3:
        final list = await StorageAudioPlayerFactory().getModelsFromStorage();
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ArtistsView(
            models: list,
          ),
        ));
        break;
      case 6:
        final list = await StorageAudioPlayerFactory()
            .getUserModelsFromStorage(user!.id);
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserSongsView(
            models: list,
            user: user,
          ),
        ));
        break;
      case 7:
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const UploadSongView(),
        ));
    }
  }

  buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = secondaryColor;
    const hoverColor = additionalColor;

    var borderRadius = const BorderRadius.all(Radius.circular(8));
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: const TextStyle(color: color),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  buildHeader({required AuthUser? user, VoidCallback? onTap}) => InkWell(
        child: InkWell(
          splashColor: subColor,
          onTap: onTap,
          child: Ink(
            color: additionalColor,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: subColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      UserProfileImagePlayerFactory.getUserProfileImage(
                          user!.userProfileImage!),
                      width: 55,
                      height: 55,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userName!,
                      style: const TextStyle(
                        fontSize: 24,
                        color: mainColor,
                      ),
                    ),
                    Text(
                      user.email,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 11,
                        color: subColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
