import 'package:flutter/material.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';

Future<void> showSongTextDialog(
    BuildContext context, String? songLyrics, String? songTags) {
  return showGenericDialog(
      context: context,
      title: 'Song lyrics',
      content: textContainer(songLyrics!, songTags),
      optionBuilder: () => {});
}

Widget textContainer(String? songLyrics, String? songTags) {
  return SizedBox(
    height: 300.0,
    width: 300.0,
    child: ListView(children: [
      Text(
        songLyrics ?? 'No song lyrics',
        style: const TextStyle(color: mainColor, fontSize: 20),
        maxLines: 10,
      ),
      const SizedBox(
        height: 100,
      ),
      const Text(
        'Tags:',
        style: TextStyle(color: mainColor, fontSize: 14),
      ),
      const SizedBox(
        height: 10,
      ),
      songTags != null ? tagsContainer(songTags) : const Text('No song tags')
    ]),
  );
}

Widget tagsContainer(String songTags) {
  List<String> result = songTags.split(' ');
  return Wrap(
    children: List.generate(
      result.length,
      (index) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 50,
          height: 30,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              result[index],
              style: const TextStyle(color: additionalColor, fontSize: 12),
            ),
          ),
        ),
      ),
    ),
  );
}
