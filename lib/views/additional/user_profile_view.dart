import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/repository/user_profile_image_factory.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/profile_image_dialog.dart';
import 'package:oktava/utilities/widgets/text_field_widget.dart';

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
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.user.email);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                MaterialPageRoute(builder: (context) => const HomePage()));
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                InkWell(
                  splashColor: mainColor,
                  onTap: () async {
                    var result = await showProfileImagesDialog(
                        widget.user.userProfileImage!, context);
                    if (result != null) {
                      context.read<AuthBloc>().add(
                          AuthEventUpdateUser(null, result, widget.user.id));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomePage()));
                    }
                  },
                  child: Stack(
                    children: [
                      Ink(
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: mainColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(155),
                            child: Image.asset(
                              UserProfileImagePlayerFactory.getUserProfileImage(
                                  widget.user.userProfileImage!),
                              width: 90,
                              height: 90,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: additionalColor.withOpacity(0.5),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.photo_album_outlined,
                            size: 40,
                            color: mainColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              const TextStyle(color: mainColor, fontSize: 14),
                        ),
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
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          'Profile is verified',
                          style: TextStyle(color: mainColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'User Name',
            text: widget.user.userName!,
            onChange: (name) {},
            userId: widget.user.id,
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold, color: mainColor),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              fillColor: secondaryColor,
              filled: true,
            ),
            style: const TextStyle(color: mainColor),
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: additionalColor,
                shadowColor: Colors.transparent,
                onSurface: mainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              onPressed: () {
                final email = controller.text;
                context.read<AuthBloc>().add(
                      AuthEventForgotPassword(email: email),
                    );
              },
              child: const Text(
                'Reset Password',
                style: TextStyle(color: mainColor, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
