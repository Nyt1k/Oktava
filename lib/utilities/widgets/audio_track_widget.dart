import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

class AudioTrackWidget extends StatelessWidget {
  const AudioTrackWidget({
    Key? key,
    required this.audioPlayerModel,
  }) : super(key: key);

  final AudioPlayerModel audioPlayerModel;

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
                  width: 60,
                  height: 60,
                ),
              ],
            ),
            title: setTitle(),
            subtitle: setSubTitle(),
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
      return const Icon(
        Icons.pause_circle_filled_rounded,
        color: mainColor,
        size: 34,
      );
    } else {
      return const Icon(
        Icons.play_circle_fill_rounded,
        color: mainColor,
        size: 34,
      );
    }
  }

  Widget setLeading() {
    return Image.asset(
      audioPlayerModel.audio.metas.image!.path,
      color: Colors.white.withOpacity(0.6),
      colorBlendMode: BlendMode.modulate,
    );
  }

  Widget setTitle() {
    return Text(
      audioPlayerModel.audio.metas.title!,
      style: const TextStyle(color: mainColor),
    );
  }

  Widget setSubTitle() {
    return Text(
      audioPlayerModel.audio.metas.artist!,
      style: const TextStyle(color: mainColor),
    );
  }

  Future<Widget> setLength() async {
    final metadata =
        await MetadataRetriever.fromFile(File(audioPlayerModel.audio.path));

    int? duration = metadata.trackDuration;

    return Text(duration.toString());
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
            .add(TriggeredPlayAudioPlayerEvent(audioPlayerModel));
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


