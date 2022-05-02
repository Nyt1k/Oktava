import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/audio_track_widget.dart';
import 'package:oktava/utilities/widgets/custom_progress_indicator.dart';
import 'package:oktava/utilities/widgets/player_widget.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({Key? key}) : super(key: key);

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

class _AudioPlayerViewState extends State<AudioPlayerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: secondaryColor,
      child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
        builder: (context, state) {
          if (state is AudioPlayerInitialState) {
            // BlocProvider.of<AudioPlayerBloc>(context)
            //     .add(const InitializeAudioPlayerEvent());
            return buildCircularProgress();
          } else if (state is AudioPlayerReadyState) {
            return buildReadyTrackList(state);
          } else if (state is AudioPlayerPlayingState) {
            return buildPlayingTrackList(state);
          } else if (state is AudioPlayerPausedState) {
            return buildPausedTrackList(state);
          } else {
            return buildUnknownStateError();
          }
        },
      ),
    );
  }
}

// class AudioPlayerView extends StatelessWidget {
//   const AudioPlayerView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
//         builder: (context, state) {
//           if (state is AudioPlayerInitialState) {
//             BlocProvider.of<AudioPlayerBloc>(context)
//                 .add(const InitializeAudioPlayerEvent());
//             return buildCircularProgress();
//           } else if (state is AudioPlayerReadyState) {
//             return buildReadyTrackList(state);
//           } else if (state is AudioPlayerPlayingState) {
//             return buildPlayingTrackList(state);
//           } else if (state is AudioPlayerPausedState) {
//             return buildPausedTrackList(state);
//           } else {
//             return buildUnknownStateError();
//           }
//         },
//       ),
//     );
//   }

Widget buildReadyTrackList(AudioPlayerReadyState state) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return AudioTrackWidget(
        audioPlayerModel: state.entityList[index],
      );
    },
    itemCount: state.entityList.length,
  );
}

Widget buildPlayingTrackList(AudioPlayerPlayingState state) {
  return Stack(
    fit: StackFit.expand,
    alignment: Alignment.topCenter,
    children: <Widget>[
      Container(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 124),
          itemBuilder: (context, index) {
            return AudioTrackWidget(
              audioPlayerModel: state.entityList[index],
            );
          },
          itemCount: state.entityList.length,
        ),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: const PlayerWidget(),
      )
    ],
  );
}

Widget buildPausedTrackList(AudioPlayerPausedState state) {
  return Stack(
    fit: StackFit.expand,
    alignment: Alignment.topCenter,
    children: <Widget>[
      Container(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 96),
          itemBuilder: (context, index) {
            return AudioTrackWidget(
              audioPlayerModel: state.entityList[index],
            );
          },
          itemCount: state.entityList.length,
        ),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: const PlayerWidget(),
      )
    ],
  );
}

Widget buildCircularProgress() {
  return customCircularIndicator();
}

Widget buildUnknownStateError() {
  return const Text("Unknown state error");
}
