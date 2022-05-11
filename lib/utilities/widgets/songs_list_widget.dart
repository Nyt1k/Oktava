import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/storage/storage_audio_player_factory.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/delete_song_dialog.dart';
import 'package:oktava/utilities/dialogs/loading_dialog.dart';
import 'package:oktava/utilities/dialogs/update_song_dialog.dart';
import 'package:oktava/views/additional/user_songs_view.dart';

class SongsListWidget extends StatefulWidget {
  final AudioPlayerModel audioPlayerModel;
  final AuthUser user;
  const SongsListWidget(
      {Key? key, required this.audioPlayerModel, required this.user})
      : super(key: key);

  @override
  State<SongsListWidget> createState() => _SongsListWidgetState();
}

class _SongsListWidgetState extends State<SongsListWidget> {
  final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: additionalColor,
            boxShadow: [
              BoxShadow(
                color: additionalColor,
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ListTile(
            leading: setLeading(),
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: setTitle(),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: setSubTitle(),
            ),
            trailing: setTrailing(),
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget setLeading() {
    return SizedBox(
      width: 60,
      height: 60,
      child: Image.network(
        widget.audioPlayerModel.audio.metas.image!.path.isNotEmpty
            ? widget.audioPlayerModel.audio.metas.image!.path
            : widget.audioPlayerModel.audio.metas.onImageLoadFail!.path,
        color: Colors.white.withOpacity(0.6),
        colorBlendMode: BlendMode.modulate,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget setTitle() {
    return Text(
      widget.audioPlayerModel.audio.metas.title!,
      style: const TextStyle(color: mainColor, fontSize: 20),
    );
  }

  Widget setSubTitle() {
    return Text(
      widget.audioPlayerModel.audio.metas.artist!,
      style: const TextStyle(color: mainColor),
    );
  }

  Widget setTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: IconButton(
            onPressed: () async {
              final shouldUpdate =
                  await showUpdateSongDialog(context, widget.audioPlayerModel);
              if (shouldUpdate != null) {
                await updateSong(shouldUpdate);
                setState(() {});
              }
            },
            splashColor: mainColor,
            icon: const Icon(
              Icons.update_rounded,
              size: 30,
              color: mainColor,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteSongDialog(
                  context, widget.audioPlayerModel.audio.metas.title!);
              if (shouldDelete) {
                showLoadingDialog(context, 'Deleting image');
                await StorageAudioPlayerFactory().deleteModelFromStorage(
                  widget.audioPlayerModel.id,
                  widget.audioPlayerModel.audio.path,
                  widget.audioPlayerModel.audio.metas.image!.path,
                );
                final list = await StorageAudioPlayerFactory()
                    .getUserModelsFromStorage(widget.user.id);
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserSongsView(
                    models: list,
                    user: widget.user,
                  ),
                ));
              }
            },
            splashColor: mainColor,
            icon: const Icon(
              Icons.delete_rounded,
              size: 30,
              color: mainColor,
            ),
          ),
        ),
      ],
    );
  }

  updateSong(AudioPlayerModel model) async {
    var data = {
      "song_name": model.audio.metas.title,
      "song_album": model.audio.metas.album,
      "song_tags": model.songTags,
      "song_text": model.songText,
      "song_image": model.audio.metas.image!.path,
    };

    await firebaseInstance.collection('songs').doc(model.id).update(data);
  }
}
