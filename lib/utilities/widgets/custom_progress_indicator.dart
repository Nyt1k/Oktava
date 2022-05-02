import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

Widget customCircularIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: mainColor,
      strokeWidth: 2,
    ),
  );
}
