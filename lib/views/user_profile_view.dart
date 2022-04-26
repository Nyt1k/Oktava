import 'package:flutter/material.dart';
import 'package:oktava/data/repository/user_profile_image_factory.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/profile_image_dialog.dart';

class UserProfileView extends StatefulWidget {
  final AuthUser user;
  const UserProfileView({Key? key, required this.user})
      : super(
          key: key,
        );

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: additionalColor,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            hoverColor: mainColor,
            color: mainColor,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
          ),
          title: const Text(
            'User Profile',
            style: TextStyle(color: mainColor),
          ),
          elevation: 0,
          backgroundColor: additionalColor,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              color: secondaryColor,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    splashColor: subColor,
                    onTap: () {
                      showProfileImagesDialog(
                          widget.user.userProfileImage, context);
                    },
                    child: Ink(
                      child: CircleAvatar(
                        radius: 65.0,
                        backgroundColor: mainColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(155),
                          child: Image.asset(
                            UserProfileImagePlayerFactory.getUserProfileImage(
                                widget.user.userProfileImage!),
                            width: 120,
                            height: 120,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.user.userName!,
                            style:
                                const TextStyle(color: mainColor, fontSize: 22),
                          ),
                          const SizedBox(
                            width: 175,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.user.email,
                            style:
                                const TextStyle(color: mainColor, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 0, 183, 40),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 0, 183, 40),
                                      blurRadius: 6.0,
                                      spreadRadius: 2.0,
                                      offset: Offset(
                                        0.0,
                                        0.0,
                                      ))
                                ]),
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Profile is verified',
                            style: TextStyle(color: mainColor, fontSize: 18),
                          ),
                          const SizedBox(
                            width: 45,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
