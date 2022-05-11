import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/widgets/songs_list_widget.dart';

class UserSongsView extends StatefulWidget {
  final List<AudioPlayerModel> models;
  final AuthUser user;
  const UserSongsView({
    Key? key,
    required this.models,
    required this.user,
  }) : super(key: key);

  @override
  State<UserSongsView> createState() => _UserSongsViewState();
}

class _UserSongsViewState extends State<UserSongsView> {
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
                    .add(InitializeAudioPlayerEvent(null));
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              });
            },
          ),
          title: const Text(
            "Your songs",
            style: TextStyle(
              color: mainColor,
            ),
          ),
          elevation: 0,
          backgroundColor: secondaryColor,
        ),
      ),
      body: ListView.builder(
          itemCount: widget.models.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: SongsListWidget(
                audioPlayerModel: widget.models[index],
                user: widget.user,
              ),
            );
          }),
    );
  }
}
