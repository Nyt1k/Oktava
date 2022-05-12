import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

class AudioTrackWidget extends StatelessWidget {
  const AudioTrackWidget({
    Key? key,
    required this.audioPlayerModel,
    required this.isFavorite,
  }) : super(key: key);

  final AudioPlayerModel audioPlayerModel;
  final bool isFavorite;

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
            leading: Stack(
              children: <Widget>[
                setLeading(),
                SizedBox(
                  child: setIcon(),
                ),
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: setTitle(),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: setSubTitle(),
            ),
            trailing: setTrailing(isFavorite, context),
            onTap: setCallBack(context),
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget setIcon() {
    if (audioPlayerModel.isPlaying) {
      return GifView.asset(
        'assets/images/equalizer.gif',
        frameRate: 10,
        color: mainColor,
        width: 60,
        height: 40,
        fit: BoxFit.contain,
      );
    } else {
      return const SizedBox(
        width: 60,
        height: 60,
        child: Icon(
          Icons.play_circle_fill_rounded,
          color: mainColor,
          size: 34,
        ),
      );
    }
  }

  Widget setLeading() {
    return SizedBox(
      width: 60,
      height: 60,
      child: Image.network(
        audioPlayerModel.audio.metas.image!.path.isNotEmpty
            ? audioPlayerModel.audio.metas.image!.path
            : audioPlayerModel.audio.metas.onImageLoadFail!.path,
        color: Colors.white.withOpacity(0.6),
        colorBlendMode: BlendMode.modulate,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget setTitle() {
    return Text(
      audioPlayerModel.audio.metas.title!,
      style: const TextStyle(color: mainColor, fontSize: 20),
    );
  }

  Widget setSubTitle() {
    return Text(
      audioPlayerModel.audio.metas.artist!,
      style: TextStyle(color: mainColor.withAlpha(180)),
    );
  }

  Widget setTrailing(bool isFavorite, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 14,
                  color: mainColor.withAlpha(120),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  audioPlayerModel.likes.toString(),
                  style: TextStyle(color: mainColor.withAlpha(180)),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  size: 14,
                  color: mainColor.withAlpha(120),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  audioPlayerModel.plays.toString(),
                  style: TextStyle(color: mainColor.withAlpha(180)),
                )
              ],
            )
          ],
        ),
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: IconButton(
            onPressed: () async {
              if (isFavorite) {
                await FirebaseAuthProvider().updateAuthUSer(
                    userId: FirebaseAuthProvider().currentUser!.id,
                    userFavoritesSong: audioPlayerModel.id,
                    isFavorite: true,
                    songId: audioPlayerModel.id);
              } else {
                await FirebaseAuthProvider().updateAuthUSer(
                    userId: FirebaseAuthProvider().currentUser!.id,
                    userFavoritesSong: audioPlayerModel.id,
                    isFavorite: false,
                    songId: audioPlayerModel.id);
              }
              BlocProvider.of<AudioPlayerBloc>(context)
                  .add(const AudioItemsRefreshAudioPlayerEvent());
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
            },
            splashColor: mainColor,
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: mainColor,
            ),
          ),
        ),
      ],
    );
  }

  void Function() setCallBack(BuildContext context) {
    if (audioPlayerModel.isPlaying) {
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPauseAudioPlayerEvent(audioPlayerModel));
      };
    } else {
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPlayAudioPlayerEvent(audioPlayerModel, context));
      };
    }
  }
}



// class AudioTrackWidget extends StatefulWidget {
//   const AudioTrackWidget({Key? key, required this.audioPlayerModel})
//       : super(key: key);
//   final AudioPlayerModel audioPlayerModel;
//   @override
//   State<AudioTrackWidget> createState() => _AudioTrackWidgetState();
// }

// class _AudioTrackWidgetState extends State<AudioTrackWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           color: additionalColor,
//           child: ListTile(
//             leading: Stack(
//               children: <Widget>[
//                 setLeading(),
//                 SizedBox(
//                   child: setIcon(),
//                   width: 60,
//                   height: 60,
//                 ),
//               ],
//             ),
//             title: setTitle(),
//             subtitle: setSubTitle(),
//             onTap: setCallBack(context),
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         )
//       ],
//     );
//   }

//   Widget setIcon() {
//     if (widget.audioPlayerModel.isPlaying) {
//       return const Icon(
//         Icons.pause,
//         color: mainColor,
//       );
//     } else {
//       return const Icon(
//         Icons.play_arrow,
//         color: mainColor,
//       );
//     }
//   }

//   Widget setLeading() {
//     return Image.asset(widget.audioPlayerModel.audio.metas.image!.path);
//   }

//   Widget setTitle() {
//     return Text(
//       widget.audioPlayerModel.audio.metas.title!,
//       style: const TextStyle(color: mainColor),
//     );
//   }

//   Widget setSubTitle() {
//     return Text(
//       widget.audioPlayerModel.audio.metas.artist!,
//       style: const TextStyle(color: mainColor),
//     );
//   }

//   Future<Widget> setLength() async {
//     final metadata = await MetadataRetriever.fromFile(
//         File(widget.audioPlayerModel.audio.path));

//     int? duration = metadata.trackDuration;

//     return Text(duration.toString());
//   }

//   void Function() setCallBack(BuildContext context) {
//     if (widget.audioPlayerModel.isPlaying) {
//       return () {
//         BlocProvider.of<AudioPlayerBloc>(context)
//             .add(TriggeredPauseAudioPlayerEvent(widget.audioPlayerModel));
//       };
//     } else {
//       return () {
//         BlocProvider.of<AudioPlayerBloc>(context)
//             .add(TriggeredPlayAudioPlayerEvent(widget.audioPlayerModel));
//       };
//     }
//   }
// }


