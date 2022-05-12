import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';
import 'package:oktava/services/auth/auth_service.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';
import 'package:oktava/services/storage/storage_audio_player_factory.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/audio_track_widget.dart';
import 'package:oktava/utilities/widgets/custom_progress_indicator.dart';
import 'package:oktava/utilities/widgets/player_widget.dart';
import 'package:oktava/views/album/albums_view.dart';

class AlbumListView extends StatefulWidget {
  final List<AudioPlayerModel> album;
  final AuthUser user;
  const AlbumListView({
    Key? key,
    required this.album,required this.user,
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
  void dispose() {
    super.dispose();
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
                        models: list, user: widget.user,
                      )));
            },
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
                  state, AlbumListView(album: widget.album, user: widget.user,));
            } else if (state is AudioPlayerPausedState) {
              return buildPausedTrackList(
                  state, AlbumListView(album: widget.album, user: widget.user,));
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
        Container(
          padding: const EdgeInsets.all(15.0),
          height: 200,
          child: Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withAlpha(120),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    state.entityList[0].audio.metas.image!.path.isNotEmpty
                        ? state.entityList[0].audio.metas.image!.path
                        : state.entityList[0].audio.metas.onImageLoadFail!.path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.entityList[0].audio.metas.album!,
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: mainColor.withAlpha(180)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.entityList[0].audio.metas.artist!,
                          style: TextStyle(
                              fontSize: 25, color: mainColor.withAlpha(130)),
                        ),
                        Text(
                          'Tracks: ' + state.entityList.length.toString(),
                          style: TextStyle(
                              fontSize: 25, color: mainColor.withAlpha(130)),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
        Container(
          padding: const EdgeInsets.all(15.0),
          height: 200,
          child: Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withAlpha(120),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    state.entityList[0].audio.metas.image!.path.isNotEmpty
                        ? state.entityList[0].audio.metas.image!.path
                        : state.entityList[0].audio.metas.onImageLoadFail!.path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.entityList[0].audio.metas.album!,
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: mainColor.withAlpha(180)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.entityList[0].audio.metas.artist!,
                          style: TextStyle(
                              fontSize: 25, color: mainColor.withAlpha(130)),
                        ),
                        Text(
                          'Tracks: ' + state.entityList.length.toString(),
                          style: TextStyle(
                              fontSize: 25, color: mainColor.withAlpha(130)),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
        Container(
          padding: const EdgeInsets.all(15.0),
          height: 200,
          child: Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withAlpha(120),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    state.entityList[0].audio.metas.image!.path.isNotEmpty
                        ? state.entityList[0].audio.metas.image!.path
                        : state.entityList[0].audio.metas.onImageLoadFail!.path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.entityList[0].audio.metas.album!,
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: mainColor.withAlpha(180)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.entityList[0].audio.metas.artist!,
                          style: TextStyle(
                              fontSize: 25, color: mainColor.withAlpha(130)),
                        ),
                        Text(
                          'Tracks: ' + state.entityList.length.toString(),
                          style: TextStyle(
                              fontSize: 25, color: mainColor.withAlpha(130)),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
