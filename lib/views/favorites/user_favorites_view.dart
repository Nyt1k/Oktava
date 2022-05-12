import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/audio_track_widget.dart';
import 'package:oktava/utilities/widgets/custom_progress_indicator.dart';
import 'package:oktava/utilities/widgets/player_widget.dart';

class UserFavoritesView extends StatefulWidget {
  final List<AudioPlayerModel> models;
  final AuthUser user;
  const UserFavoritesView({
    Key? key,
    required this.models,
    required this.user,
  }) : super(key: key);

  @override
  State<UserFavoritesView> createState() => _UserFavoritesViewState();
}

class _UserFavoritesViewState extends State<UserFavoritesView> {
  // List<AudioPlayerModel> favoritesList = [];

  @override
  void initState() {
    super.initState();
    // for (var name in widget.user.userFavorites!) {
    //   for (var model in widget.models) {
    //     if (name == model.id) {
    //       favoritesList.add(model);
    //     }
    //   }
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
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
              setState(() {
                BlocProvider.of<AudioPlayerBloc>(context)
                    .add(const InitializeAudioPlayerEvent(null));
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              });
            },
          ),
          title: const Text(
            "Songs you like",
            style: TextStyle(
              color: mainColor,
            ),
          ),
          elevation: 0,
          backgroundColor: secondaryColor,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: secondaryColor,
        child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
          builder: (context, state) {
            if (state is AudioPlayerInitialState) {
              BlocProvider.of<AudioPlayerBloc>(context)
                  .add(InitializeAudioPlayerEvent(widget.models));
              return buildCircularProgress();
            } else if (state is AudioPlayerReadyState) {
              return buildReadyTrackList(state);
            } else if (state is AudioPlayerPlayingState) {
              return buildPlayingTrackList(
                  state,
                  UserFavoritesView(
                    models: state.entityList,
                    user: widget.user,
                  ));
            } else if (state is AudioPlayerPausedState) {
              return buildPausedTrackList(
                  state,
                  UserFavoritesView(
                    models: state.entityList,
                    user: widget.user,
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
