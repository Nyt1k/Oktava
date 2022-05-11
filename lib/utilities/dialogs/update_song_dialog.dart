import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/constants/photo_constants.dart';
import 'package:oktava/utilities/dialogs/generic_dialog.dart';
import 'package:oktava/utilities/dialogs/loading_dialog.dart';

AudioPlayerModel? newModel;
TextEditingController songName = TextEditingController();
TextEditingController songAlbum = TextEditingController();
TextEditingController songTags = TextEditingController();
TextEditingController songText = TextEditingController();
String songImage = '';

Future<AudioPlayerModel?> showUpdateSongDialog(
    BuildContext context, AudioPlayerModel model) async {
  final answer = await showGenericDialog<bool>(
      context: context,
      title: 'Update song',
      content: updateSongDialog(context, model),
      optionBuilder: () => {
            'Cancel': false,
            'Update': true,
          }).then((value) => value ?? false);

  if (answer) {
    newModel!.audio.updateMetas(title: songName.text, album: songAlbum.text);
    newModel!.songTags = model.songTags!;
    newModel!.songText = model.songText!;
    return newModel;
  }
  return null;
}

String fileName = '';

Widget updateSongDialog(BuildContext context, AudioPlayerModel model) {
  songName.text = model.audio.metas.title!;
  songAlbum.text = model.audio.metas.album!;
  songTags.text = model.songTags!;
  songText.text = model.songText!;

  newModel =
      AudioPlayerModel(id: model.id, audio: model.audio, isPlaying: false);
  return SizedBox(
    height: 500,
    width: 350,
    child: ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Text(
                'Change song image',
                style: TextStyle(color: mainColor),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 250,
                width: 250,
                child: Ink(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                        color: mainColor, width: 2.0, style: BorderStyle.solid),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          newModel!.audio.metas.image!.path.isNotEmpty
                              ? newModel!.audio.metas.image!.path
                              : defaultSongImage),
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.6), BlendMode.dstATop),
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                          child: Icon(
                        Icons.image_outlined,
                        size: 55,
                        color: mainColor,
                      )),
                      InkWell(
                        onTap: () async {
                          showLoadingDialog(context, 'Selecting image');
                          songImage = (await selectImage())!;
                          newModel?.audio.updateMetas(
                              image: MetasImage(
                                  path: songImage, type: ImageType.network));
                          model.audio.updateMetas(
                              image: MetasImage(
                                  path: songImage, type: ImageType.network));
                          Navigator.pop(context);
                        },
                        splashColor: mainColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  children: [
                    TextField(
                      controller: songName,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        hintText: 'Enter song name',
                        hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                        prefixIcon: const Icon(
                          Icons.music_note_rounded,
                          color: subColor,
                        ),
                      ),
                      style: const TextStyle(color: mainColor),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: songAlbum,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        hintText: 'Enter album name',
                        hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                        prefixIcon: const Icon(
                          Icons.album_rounded,
                          color: subColor,
                        ),
                      ),
                      style: const TextStyle(color: mainColor),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: songTags,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        hintText: 'Enter song tags',
                        hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                        prefixIcon: const Icon(
                          Icons.tag_sharp,
                          color: subColor,
                        ),
                      ),
                      style: const TextStyle(color: mainColor),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      maxLines: 5,
                      controller: songText,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 2.0),
                        ),
                        hintText: 'Enter song lyrics...',
                        hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                      ),
                      style: const TextStyle(color: mainColor),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

late Reference storageRef;

Future<String?> selectImage() async {
  final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
      ],
      withData: true);
  if (result != null) {
    final image = result.files.first;
    final imageBytes = image.bytes;
    final imageName = image.name;

    storageRef = FirebaseStorage.instance.ref().child('images/$imageName');
    final uploadTask = storageRef.putData(imageBytes!);

    var imageDownUrl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();

    return imageDownUrl;
  }
  return null;
}
