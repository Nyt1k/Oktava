import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';
import 'package:oktava/services/storage/storage_audio_player_factory.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/audio_track_widget.dart';
import 'package:oktava/utilities/widgets/custom_progress_indicator.dart';
import 'package:oktava/utilities/widgets/player_widget.dart';
import 'package:oktava/views/albums_view.dart';

class AlbumListView extends StatefulWidget {
  final List<AudioPlayerModel> album;
  const AlbumListView({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  State<AlbumListView> createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: additionalColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
            ),
            splashRadius: 15,
            hoverColor: mainColor,
            splashColor: mainColor,
            color: mainColor,
            onPressed: () async {
              final list =
                  await StorageAudioPlayerFactory().getModelsFromStorage();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AlbumsView(
                        models: list,
                      )));
            },
          ),
          title: const Text(
            "Albums",
            style: TextStyle(
              color: mainColor,
            ),
          ),
          elevation: 0,
          backgroundColor: additionalColor,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: secondaryColor,
        child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
          builder: (context, state) {
            if (state is AudioPlayerInitialState) {
              BlocProvider.of<AudioPlayerBloc>(context)
                  .add(InitializeAudioPlayerEvent(widget.album));
              return buildCircularProgress();
            } else if (state is AudioPlayerReadyState) {
              return buildReadyTrackList(state);
            } else if (state is AudioPlayerPlayingState) {
              return buildPlayingTrackList(
                  state, AlbumListView(album: widget.album));
            } else if (state is AudioPlayerPausedState) {
              return buildPausedTrackList(
                  state, AlbumListView(album: widget.album));
            } else {
              return buildUnknownStateError();
            }
          },
        ),
      ),
    );
  }
}

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

Widget buildPlayingTrackList(AudioPlayerPlayingState state, dynamic backRoute) {
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
        child: PlayerWidget(
          backRoute: backRoute,
        ),
      )
    ],
  );
}

Widget buildPausedTrackList(AudioPlayerPausedState state, dynamic backRoute) {
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
        child: PlayerWidget(
          backRoute: backRoute,
        ),
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
