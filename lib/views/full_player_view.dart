import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: additionalColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          hoverColor: mainColor,
          color: mainColor,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        elevation: 0,
        backgroundColor: additionalColor,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Center(
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      StreamBuilder<Playing?>(
                        stream: _assetsAudioPlayer.current,
                        builder: (context, playing) {
                          if (playing.data != null) {
                            final myAudio =
                                find(list, playing.data!.audio.assetAudioPath);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 300,
                                height: 300,
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
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      // const SizedBox(height: 20,)
                      // _assetsAudioPlayer.builderCurrent(builder: (context, Playing? playing){

                      // })
                    ],
                  )
                ],
              ),
            )),
      )),
    );
  }
}
