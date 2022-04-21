import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        if (state is AudioPlayerInitialState ||
            state is AudioPlayerReadyState) {
          return const SizedBox.shrink();
        }

        if (state is AudioPlayerPlayingState) {
          return _showPlayer(context, state.playingEntity);
        }

        if (state is AudioPlayerPausedState) {
          return _showPlayer(context, state.pausedEntity);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _showPlayer(BuildContext context, AudioPlayerModel model) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            color: Colors.grey.shade200,
            child: ListTile(
              leading: setLeading(model),
              title: setTitle(model),
              subtitle: setSubTitle(model),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              trailing: IconButton(
                icon: setIcon(model),
                onPressed: setCallBack(context, model),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget setIcon(AudioPlayerModel model) {
    if (model.isPlaying) {
      return const Icon(Icons.pause);
    } else {
      return const Icon(Icons.play_arrow);
    }
  }

  Widget setLeading(AudioPlayerModel model) {
    return Image.asset(model.audio.metas.image!.path);
  }

  Widget setTitle(AudioPlayerModel model) {
    return Text(model.audio.metas.title!);
  }

  Widget setSubTitle(AudioPlayerModel model) {
    return Text(model.audio.metas.artist!);
  }

  void Function() setCallBack(BuildContext context, AudioPlayerModel model) {
    if (model.isPlaying) {
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPauseAudioPlayerEvent(model));
      };
    } else {
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPlayAudioPlayerEvent(model));
      };
    }
  }
}
