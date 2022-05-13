import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/utilities/dialogs/create_new_playlist_dialog.dart';
import 'package:oktava/views/playlists/playlist_list_view.dart';

class PlaylistsView extends StatefulWidget {
  final List<AudioPlayerModel> models;
  final AuthUser user;
  const PlaylistsView({
    Key? key,
    required this.models,
    required this.user,
  }) : super(key: key);

  @override
  State<PlaylistsView> createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends State<PlaylistsView> {
  Map<String, List<AudioPlayerModel>> playlistsList = {};

  @override
  void initState() {
    super.initState();
    for (var element in widget.user.userPlaylists!) {
      List<AudioPlayerModel> list = [];
      for (var model in widget.models) {
        if (element!.playlistSongs!.any((item) => item == model.id)) {
          list.add(model);
        }
      }
      playlistsList.addAll({element!.id: list});
    }
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
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
            ),
            splashRadius: 20,
            hoverColor: mainColor,
            splashColor: mainColor,
            color: mainColor,
            onPressed: () {
              BlocProvider.of<AudioPlayerBloc>(context)
                  .add(const InitializeAudioPlayerEvent(null));
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          title: const Text(
            "Playlists",
            style: TextStyle(
              color: mainColor,
            ),
          ),
          elevation: 0,
          backgroundColor: additionalColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: IconButton(
                onPressed: () async {
                  await showCreateNewPlaylistDialog(context, widget.user);
                  Navigator.pop(context);
                  BlocProvider.of<AudioPlayerBloc>(context)
                      .add(const InitializeAudioPlayerEvent(null));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
                icon: const Icon(
                  Icons.add_box_outlined,
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
        ),
      ),
      body: Builder(builder: (context) {
        if (playlistsList.isNotEmpty) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0,
              mainAxisExtent: 150,
            ),
            itemCount: playlistsList.length,
            itemBuilder: (context, index) {
              final key = playlistsList.keys.elementAt(index);
              final playlist = playlistsList[key];
              return Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<AudioPlayerBloc>(context)
                        .add(InitializeAudioPlayerEvent(playlist));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PlaylistListView(
                              playlist: playlist!,
                              user: widget.user,
                              playListName: key,
                            )));
                  },
                  radius: 5,
                  borderRadius: BorderRadius.circular(2),
                  splashColor: mainColor,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: mainColor.withAlpha(50),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                            blurStyle: BlurStyle.normal),
                      ],
                    ),
                    child: Card(
                      color: secondaryColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              key,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor.withAlpha(220)),
                            ),
                            Text(
                              'Tracks: ' + playlist!.length.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: mainColor.withAlpha(180)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
              child: Text(
            'No Playlists',
            style: TextStyle(color: mainColor.withAlpha(140), fontSize: 20),
          ));
        }
      }),
    );
  }
}
