import 'dart:async';
import 'dart:math' as math;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/position_seek_widget.dart';
import 'package:oktava/utilities/widgets/playing_controls_widget.dart';

class FullPlayerView extends StatefulWidget {
  final List<AudioPlayerModel> models;
  const FullPlayerView({
    Key? key,
    required this.models,
  }) : super(key: key);

  @override
  State<FullPlayerView> createState() => _FullPlayerViewState();
}

class _FullPlayerViewState extends State<FullPlayerView> {
  late AssetsAudioPlayer _assetsAudioPlayer;
  final List<StreamSubscription> _subscriptions = [];
  late List<Audio> list = [];
  late AudioPlayerModel model;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer.allPlayers().entries.first.value;

    _subscriptions.add(_assetsAudioPlayer.audioSessionId.listen((sessionId) {
      print('audioSessionId : $sessionId');
    }));

    // _subscriptions.add(_assetsAudioPlayer.playlistAudioFinished.listen((event) {
    //   setState(() {});
    // }));

    openPlayer();
  }

  void openPlayer() async {
    //  await _assetsAudioPlayer.stop();
    for (var model in widget.models) {
      list.add(model.audio);
    }

    // Audio audio = Audio.network(
    //   widget.model.audio.path,
    //   metas: Metas(
    //       id: widget.model.id,
    //       title: widget.model.audio.metas.title,
    //       artist: widget.model.audio.metas.artist,
    //       album: widget.model.audio.metas.album,
    //       image: widget.model.audio.metas.image!.path != ''
    //           ? widget.model.audio.metas.image
    //           : widget.model.audio.metas.onImageLoadFail),
    // );
    // await _assetsAudioPlayer.open(
    //   audio,
    //   showNotification: true,
    //   autoStart: true,
    // );
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  void findModel(List<AudioPlayerModel> source, String fromPath) {
    model = source.firstWhere((element) => element.audio.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: additionalColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_drop_down_rounded,
              size: 30,
            ),
            splashRadius: 15,
            hoverColor: mainColor,
            splashColor: mainColor,
            color: mainColor,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          elevation: 0,
          backgroundColor: additionalColor,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: Center(
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      StreamBuilder<Playing?>(
                        stream: _assetsAudioPlayer.current,
                        builder: (context, playing) {
                          if (playing.data != null) {
                            final myAudio =
                                find(list, playing.data!.audio.assetAudioPath);
                            if (myAudio != null) {
                              findModel(widget.models,
                                  playing.data!.audio.assetAudioPath);
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    (widget.models.indexWhere((element) =>
                                                    element.audio.path ==
                                                    playing.data!.audio
                                                        .assetAudioPath) +
                                                1)
                                            .toString() +
                                        ' of ' +
                                        widget.models.length.toString(),
                                    style: const TextStyle(
                                        color: mainColor, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 350,
                                    height: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          color: mainColor,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: mainColor,
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Image.network(
                                      myAudio.metas.image!.path.isNotEmpty
                                          ? myAudio.metas.image!.path
                                          : myAudio.metas.onImageLoadFail!.path,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        myAudio.metas.artist.toString(),
                                        style: const TextStyle(
                                            color: mainColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        myAudio.metas.title.toString(),
                                        style: TextStyle(
                                          color: Color(
                                                  (math.Random().nextDouble() *
                                                          0xFFFFFF)
                                                      .toInt())
                                              .withOpacity(1.0),
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        myAudio.metas.album.toString(),
                                        style: TextStyle(
                                            color: mainColor.withAlpha(170),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  _assetsAudioPlayer.builderCurrent(
                    builder: (context, Playing? playing) {
                      return Column(
                        children: <Widget>[
                          _assetsAudioPlayer.builderRealtimePlayingInfos(
                            builder: (context, RealtimePlayingInfos? infos) {
                              if (infos == null) {
                                return const SizedBox();
                              } else {
                                return Column(
                                  children: [
                                    PositionSeekWidget(
                                        currentPosition: infos.currentPosition,
                                        duration: infos.duration,
                                        seekTo: (to) {
                                          _assetsAudioPlayer.seek(to);
                                        })
                                  ],
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _assetsAudioPlayer.builderLoopMode(
                            builder: (context, loopMode) {
                              return PlayerBuilder.isPlaying(
                                player: _assetsAudioPlayer,
                                builder: (context, isPlaying) {
                                  return PlayingControlsWidget(
                                    isPlaying: isPlaying,
                                    loopMode: loopMode,
                                    isPlaylist: true,
                                    onStop: () {
                                      BlocProvider.of<AudioPlayerBloc>(context)
                                          .add(
                                              const InitializeAudioPlayerEvent());
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()));
                                    },
                                    onPlay: () {
                                      if (isPlaying) {
                                        BlocProvider.of<AudioPlayerBloc>(
                                                context)
                                            .add(TriggeredPauseAudioPlayerEvent(
                                                model));
                                      } else {
                                        BlocProvider.of<AudioPlayerBloc>(
                                                context)
                                            .add(TriggeredPlayAudioPlayerEvent(
                                                model, context));
                                      }
                                    },
                                    toggleLoop: () {
                                      _assetsAudioPlayer.toggleLoop();
                                    },
                                    onNext: () {
                                      BlocProvider.of<AudioPlayerBloc>(context)
                                          .add(TriggeredNextAudioPlayerEvent(
                                              model));
                                    },
                                    onPrevious: () {
                                      BlocProvider.of<AudioPlayerBloc>(context)
                                          .add(TriggeredPrevAudioPlayerEvent(
                                              model));
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            )),
      )),
    );
  }
}
