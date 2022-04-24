import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/repository/user_profile_image_factory.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/auth/auth_service.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/services/auth/bloc/auth_state.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/logout_dialogs.dart';

// class NavigationDrawerWidget extends StatefulWidget {
//   const NavigationDrawerWidget({Key? key}) : super(key: key);

//   @override
//   State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
// }

// class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
//   String get userId => AuthService.firebase().currentUser!.id;

//   @override
//   void initState() {
//     //context.read<AuthBloc>().add(AuthEventGetUser(userId));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   final padding = const EdgeInsets.symmetric(horizontal: 30);

//   @override
//   Widget build(BuildContext context) {
//     const urlImage = 'assets/images/country.jpg';
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthStateGetUser) {}
//       },
//       builder: (context, state) {
//         return BlocBuilder<AuthBloc, AuthState>(
//           builder: (context, state) {
//             if (state is AuthStateGetUser) {
//               return SizedBox(
//                 width: 250,
//                 child: Drawer(
//                   child: Material(
//                     color: mainColor,
//                     child: ListView(
//                       padding: padding,
//                       children: <Widget>[
//                         buildHeader(
//                           urlImage: urlImage,
//                           user: state.user,
//                         ),
//                         Column(
//                           children: [
//                             const SizedBox(
//                               height: 8,
//                             ),
//                             buildMenuItem(
//                               text: 'All songs',
//                               icon: Icons.music_note_outlined,
//                               onClicked: () => selectedItem(context, 0),
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             buildMenuItem(
//                               text: 'Albums',
//                               icon: Icons.album_rounded,
//                               onClicked: () => selectedItem(context, 1),
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             buildMenuItem(
//                               text: 'Artists',
//                               icon: Icons.people_outline_rounded,
//                               onClicked: () => selectedItem(context, 2),
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             buildMenuItem(
//                               text: 'Genres',
//                               icon: Icons.graphic_eq_rounded,
//                               onClicked: () => selectedItem(context, 3),
//                             ),
//                             const SizedBox(
//                               height: 32,
//                             ),
//                             Container(
//                                 height: 2,
//                                 decoration: const BoxDecoration(
//                                     color: additionalColor,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10)))),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             buildMenuItem(
//                               text: 'Upload',
//                               icon: Icons.cloud_upload_rounded,
//                               onClicked: () => selectedItem(context, 4),
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             buildMenuItem(
//                               text: 'Settings',
//                               icon: Icons.settings,
//                               onClicked: () => selectedItem(context, 5),
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             buildMenuItem(
//                               text: 'Log out',
//                               icon: Icons.logout_rounded,
//                               onClicked: () => selectedItem(context, 6),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             } else {
//               context.read<AuthBloc>().add(AuthEventGetUser(userId));
//               return const MainScreen();
//             }
//           },
//         );
//       },
//     );
//   }

//   buildMenuItem({
//     required String text,
//     required IconData icon,
//     VoidCallback? onClicked,
//   }) {
//     const color = secondaryColor;
//     const hoverColor = additionalColor;

//     var borderRadius = const BorderRadius.all(Radius.circular(8));
//     return ListTile(
//       shape: RoundedRectangleBorder(borderRadius: borderRadius),
//       leading: Icon(
//         icon,
//         color: color,
//       ),
//       title: Text(
//         text,
//         style: const TextStyle(color: color),
//       ),
//       hoverColor: hoverColor,
//       onTap: onClicked,
//     );
//   }

//   Future<AuthUser> getUser() async {
//     final user = AuthService.firebase().currentUser;
//     final currentUser =
//         await AuthService.firebase().getAlreadyAuthUser(userId: user!.id);
//     return currentUser;
//   }

//   selectedItem(BuildContext context, int index) async {
//     //Navigator.of(context).pop();
//     switch (index) {
//       case 0:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => const HomePage(),
//         ));
//         break;
//       case 6:
//         final shouldLogOut = await showLogOutDialog(context);
//         if (shouldLogOut) {
//           context.read<AuthBloc>().add(
//                 const AuthEventLogOut(),
//               );
//         }
//     }
//   }

//   buildHeader({required String urlImage, required AuthUser? user}) => InkWell(
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 40),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundColor: additionalColor,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(30),
//                   child: Image.asset(urlImage),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Flexible(
//                 child: Text(
//                   user!.email,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(fontSize: 14, color: secondaryColor),
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
// }

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  String get userId => AuthService.firebase().currentUser!.id;
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateGetUser) {
          return SizedBox(
            width: 250,
            child: Drawer(
              child: Material(
                color: mainColor,
                child: ListView(
                  // padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: <Widget>[
                    buildHeader(
                      user: state.user,
                      onTap: () => selectedItem(context, 7),
                    ),
                    Container(
                      padding: padding,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          buildMenuItem(
                            text: 'All songs',
                            icon: Icons.music_note_outlined,
                            onClicked: () => selectedItem(context, 0),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          buildMenuItem(
                            text: 'Albums',
                            icon: Icons.album_rounded,
                            onClicked: () => selectedItem(context, 1),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          buildMenuItem(
                            text: 'Artists',
                            icon: Icons.people_outline_rounded,
                            onClicked: () => selectedItem(context, 2),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          buildMenuItem(
                            text: 'Genres',
                            icon: Icons.graphic_eq_rounded,
                            onClicked: () => selectedItem(context, 3),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Container(
                              height: 2,
                              decoration: const BoxDecoration(
                                  color: additionalColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          buildMenuItem(
                            text: 'Upload',
                            icon: Icons.cloud_upload_rounded,
                            onClicked: () => selectedItem(context, 4),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          buildMenuItem(
                            text: 'Settings',
                            icon: Icons.settings,
                            onClicked: () => selectedItem(context, 5),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          buildMenuItem(
                            text: 'Log out',
                            icon: Icons.logout_rounded,
                            onClicked: () => selectedItem(context, 6),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
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

  selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();
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
