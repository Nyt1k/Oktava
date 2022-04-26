import 'package:flutter/material.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';
import 'package:oktava/data/repository/user_profile_image_factory.dart';

Future<String> showProfileImagesDialog<String, bool>(
    String imageStatus, BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Pick image',
      content: imageSelector(imageStatus.toString()),
      optionBuilder: () => {
            'Cancel': false,
            'Select': true,
          }).then((value) => value ?? 'notSelected');
}

Widget imageSelector(String imageStatus) {
  final items = UserProfileImagePlayerFactory.getUserProfileImageList();
  return SizedBox(
      height: 300.0,
      width: 300.0,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) => Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.asset(items[index].imagePath),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(10),
              )));
}
