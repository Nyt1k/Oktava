import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/auth/auth_service.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/constants/photo_constants.dart';
import 'package:oktava/utilities/dialogs/loading_dialog.dart';

class UploadSongView extends StatefulWidget {
  const UploadSongView({Key? key}) : super(key: key);

  @override
  State<UploadSongView> createState() => _UploadSongViewState();
}

class _UploadSongViewState extends State<UploadSongView> {
  TextEditingController songName = TextEditingController();
  TextEditingController songAlbum = TextEditingController();
  TextEditingController songTags = TextEditingController();
  TextEditingController songText = TextEditingController();
  var songUrl;
  String songImage = '';
  late Reference storageRef;
  final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

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
            BlocProvider.of<AudioPlayerBloc>(context)
                .add(const InitializeAudioPlayerEvent(null));
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        title: const Text(
          'Upload Song',
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
            child: Column(
              children: [
                const Text(
                  'Select song file',
                  style: TextStyle(color: mainColor),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                          color: mainColor,
                          width: 2.0,
                          style: BorderStyle.solid),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                            child: Icon(
                          Icons.upload,
                          size: 45,
                          color: mainColor,
                        )),
                        InkWell(
                          onTap: () async {
                            showLoadingDialog(context, 'Selecting song');
                            var song = await selectSong();
                            songUrl = song;
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
                const Text(
                  'Select song image',
                  style: TextStyle(color: mainColor),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                          color: mainColor,
                          width: 2.0,
                          style: BorderStyle.solid),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(songImage.isNotEmpty
                            ? songImage
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
                          size: 75,
                          color: mainColor,
                        )),
                        InkWell(
                          onTap: () async {
                            showLoadingDialog(context, 'Selecting Image');
                            final image = await selectImage();

                            if (image != null) {
                              songImage = image;
                              setState(() {});
                            }
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
                  padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                  child: Column(
                    children: [
                      TextField(
                        controller: songName,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
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
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
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
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
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
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          hintText: 'Enter song lyrics...',
                          hintStyle: TextStyle(color: mainColor.withAlpha(120)),
                        ),
                        style: const TextStyle(color: mainColor),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: mainColor,
                        ),
                        onPressed: () async {
                          showLoadingDialog(context, 'Saving song');
                          await saveSong();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Upload song',
                          style: TextStyle(color: additionalColor),
                        ),
                      )
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

      var imageDownUrl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();

      return imageDownUrl;
    } else {
      return null;
    }
  }

  Future<String?> selectSong() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'aac', 'flac', 'wav'],
        withData: true);
    if (result != null) {
      final song = result.files.first;
      final songBytes = song.bytes;
      final songName = song.name;

      storageRef = FirebaseStorage.instance.ref().child('songs/$songName');
      final uploadTask = storageRef.putData(songBytes!);

      var songDownUrl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();

      return songDownUrl;
    } else {
      return null;
    }
  }

  String get userId => AuthService.firebase().currentUser!.id;
  
  saveSong() async {
    var data = {
      "song_name": songName.text,
      "song_album": songAlbum.text,
      "song_tags": songTags.text,
      "song_text": songText.text,
      "song_owner": userId,
      "song_url": songUrl,
      "song_image": songImage,
      "song_likes": 0,
      "song_plays": 0,
    };

    await firebaseInstance.collection('songs').doc().set(data);
  }
}
