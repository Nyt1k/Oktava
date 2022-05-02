import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String? title,
  required Widget content,
  required DialogOptionBuilder optionBuilder,
}) {
  final option = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: additionalColor,
        title: Center(
          child: Text(
            title!,
            style: const TextStyle(color: mainColor),
          ),
        ),
        content: content,
        actions: option.keys.map((e) {
          final value = option[e];
          return TextButton(
            style: TextButton.styleFrom(
              primary: mainColor,
            ),
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(e),
          );
        }).toList(),
      );
    },
  );
}
