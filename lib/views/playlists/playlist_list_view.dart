import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';
import 'package:oktava/services/storage/storage_audio_player_factory.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/create_new_playlist_dialog.dart';
import 'package:oktava/utilities/widgets/audio_track_widget.dart';
import 'package:oktava/utilities/widgets/custom_progress_indicator.dart';
import 'package:oktava/utilities/widgets/player_widget.dart';
import 'package:oktava/views/playlists/playlists_view.dart';

class PlaylistListView extends StatefulWidget {
  final List<AudioPlayerModel> playlist;
  final AuthUser user;
  final String playListName;
  const PlaylistListView({
    Key? key,
    required this.playlist,
    required this.user,
    required this.playListName,
  }) : super(key: key);

  @override
  State<PlaylistListView> createState() => _PlaylistListViewState();
}

class _PlaylistListViewState extends State<PlaylistListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: additionalColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
                  builder: (context) => PlaylistsView(
                        models: list,
                        user: widget.user,
                      )));
            },
          ),
          title: Text(
            widget.playListName,
            style: const TextStyle(
              color: mainColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: IconButton(
                onPressed: () async {
                  await FirebaseAuthProvider()
                      .deletePlaylist(widget.user.id, widget.playListName);
                  BlocProvider.of<AudioPlayerBloc>(context)
                      .add(const InitializeAudioPlayerEvent(null));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  size: 35,
                  color: mainColor,
                ),
                splashRadius: 28,
                hoverColor: mainColor,
                splashColor: mainColor,
                color: mainColor,
              ),
            ),
          ],
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
                  .add(InitializeAudioPlayerEvent(widget.playlist));
              return buildCircularProgress();
            } else if (state is AudioPlayerReadyState) {
              return buildReadyTrackList(state);
            } else if (state is AudioPlayerPlayingState) {
              return buildPlayingTrackList(
                  state,
                  PlaylistListView(
                    playlist: widget.playlist,
                    user: widget.user,
                    playListName: widget.playListName,
                  ));
            } else if (state is AudioPlayerPausedState) {
              return buildPausedTrackList(
                  state,
                  PlaylistListView(
                    playlist: widget.playlist,
                    user: widget.user,
                    playListName: widget.playListName,
                  ));
            } else {
              return buildUnknownStateError();
            }
          },
        ),
      ),
    );
  }

  bool isFavorite(AudioPlayerModel model) {
    if (widget.user.userFavorites != null) {
      if (widget.user.userFavorites!.contains(model.id)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget buildReadyTrackList(AudioPlayerReadyState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return AudioTrackWidget(
                audioPlayerModel: state.entityList[index],
                isFavorite: isFavorite(state.entityList[index]),
                user: widget.user,
                isPlaylist: true,
                playlistName: widget.playListName,
              );
            },
            itemCount: state.entityList.length,
          ),
        ),
      ],
    );
  }

  Widget buildPlayingTrackList(
      AudioPlayerPlayingState state, dynamic backRoute) {
    return Column(
      children: [
        Expanded(
          child: Stack(
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
                      isFavorite: isFavorite(state.entityList[index]),
                      user: widget.user,
                      isPlaylist: true,
                      playlistName: widget.playListName,
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
          ),
        ),
      ],
    );
  }

  Widget buildPausedTrackList(AudioPlayerPausedState state, dynamic backRoute) {
    return Column(
      children: [
        Expanded(
          child: Stack(
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
                      isFavorite: isFavorite(state.entityList[index]),
                      user: widget.user,
                      isPlaylist: true,
                      playlistName: widget.playListName,
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
          ),
        ),
      ],
    );
  }

  Widget buildCircularProgress() {
    return customCircularIndicator();
  }

  Widget buildUnknownStateError() {
    return const Text("Unknown state error");
  }
}
