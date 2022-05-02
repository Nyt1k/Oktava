import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';

showLoadingDialog(BuildContext context, String? text) {
  return showGenericDialog(
      context: context,
      title: text,
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: mainColor,
            strokeWidth: 2,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text(
              "Loading...",
              style: TextStyle(color: mainColor),
            ),
          ),
        ],
      ),
      optionBuilder: () => {});
}
