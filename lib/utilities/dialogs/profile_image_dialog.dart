import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';
import 'package:oktava/data/repository/user_profile_image_factory.dart';

String? updatedImage;

Future<String?> showProfileImagesDialog(
    String imageStatus, BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Pick image',
      content: imageSelector(imageStatus.toString()),
      optionBuilder: () => {}).then((value) => updatedImage);
}

Widget imageSelector(String imageName) {
  updatedImage = null;
  final items = UserProfileImagePlayerFactory.getUserProfileImageList();
  return SizedBox(
    height: 300.0,
    width: 300.0,
    child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: () {
              selectItem(item, context, imageName);
              Navigator.pop(context);
            },
            splashColor: mainColor,
            radius: 220,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: imageName == item.imageName
                    ? mainColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.asset(items[index].imagePath),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(10),
              ),
            ),
          );
        }),
  );
}

selectItem(UserProfileImage item, BuildContext context, String imageName) {
  final name = item.imageName;
  final snackBar = SnackBar(
    content: Text(
      'Selected $name',
      style: const TextStyle(color: subColor),
    ),
    backgroundColor: secondaryColor,
  );

  if (item.imageName != imageName) {
    updatedImage = item.imageName;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  } else {
    updatedImage = null;
  }
}
