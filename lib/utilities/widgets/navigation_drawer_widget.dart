import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/utilities/dialogs/logout_dialogs.dart';
import 'package:oktava/views/audio_player_view.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 40);
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 145, 245, 230),
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(
              height: 32,
            ),
            buildMenuItem(
              text: 'All songs',
              icon: Icons.music_note_outlined,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(
              height: 32,
            ),
            buildMenuItem(
              text: 'Albums',
              icon: Icons.album_rounded,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(
              height: 32,
            ),
            buildMenuItem(
              text: 'Artists',
              icon: Icons.people_outline_rounded,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(
              height: 32,
            ),
            buildMenuItem(
              text: 'Genres',
              icon: Icons.graphic_eq_rounded,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(
              height: 32,
            ),
            const Divider(
              thickness: 3.0,
              color: Color.fromARGB(255, 39, 39, 39),
            ),
            const SizedBox(
              height: 64,
            ),
            const SizedBox(
              height: 24,
            ),
            buildMenuItem(
              text: 'Upload',
              icon: Icons.cloud_upload_rounded,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(
              height: 24,
            ),
            buildMenuItem(
              text: 'Settings',
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 5),
            ),
            const SizedBox(
              height: 24,
            ),
            buildMenuItem(
              text: 'Log out',
              icon: Icons.logout_rounded,
              onClicked: () => selectedItem(context, 6),
            ),
          ],
        ),
      ),
    );
  }

  buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Color.fromARGB(255, 73, 73, 73);
    const hoverColor = Color.fromARGB(255, 39, 39, 39);

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

  selectedItem(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
        break;
      case 6:
        final shouldLogOut = await showLogOutDialog(context);
        if (shouldLogOut) {
          context.read<AuthBloc>().add(
                const AuthEventLogOut(),
              );
        }
    }
  }
}
