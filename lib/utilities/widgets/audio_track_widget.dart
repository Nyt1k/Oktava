import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';

class AudioTrackWidget extends StatelessWidget {
  const AudioTrackWidget({Key? key, required this.audioPlayerModel})
      : super(key: key);

  final AudioPlayerModel audioPlayerModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Material(child: setLeading()),
        title: Material(child: setTitle()),
        subtitle: Material(child: setSubTitle()),
        trailing: Material(
          child: IconButton(
            icon: Material(child: setIcon()),
            onPressed: setCallBack(context),
          ),
        ),
      ),
    );
  }

  Widget setIcon() {
    if (audioPlayerModel.isPlaying) {
      return const Icon(Icons.pause);
    } else {
      return const Icon(Icons.play_arrow);
    }
  }

  Widget setLeading() {
    return Image.asset(audioPlayerModel.audio.metas.image!.path);
  }

  Widget setTitle() {
    return Text(audioPlayerModel.audio.metas.title!);
  }

  Widget setSubTitle() {
    return Text(audioPlayerModel.audio.metas.artist!);
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
