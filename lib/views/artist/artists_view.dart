import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_bloc.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/views/artist/artist_list_view.dart';

class ArtistsView extends StatefulWidget {
  final List<AudioPlayerModel> models;
  const ArtistsView({Key? key, required this.models}) : super(key: key);

  @override
  State<ArtistsView> createState() => _ArtistsViewState();
}

class _ArtistsViewState extends State<ArtistsView> {
  List<List<AudioPlayerModel>> artistsList = [];
  Set<String> albumList = <String>{};

  @override
  void initState() {
    super.initState();
    var seen = <String>{};
    widget.models
        .where((element) => seen.add(element.audio.metas.artist!))
        .toList();

    for (var uniqueName in seen) {
      List<AudioPlayerModel> list = [];
      for (var model in widget.models) {
        if (model.audio.metas.artist == uniqueName) {
          list.add(model);
        }
      }
      artistsList.add(list);
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
            onPressed: () {
              BlocProvider.of<AudioPlayerBloc>(context)
                  .add(const InitializeAudioPlayerEvent(null));
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          title: const Text(
            "Artists",
            style: TextStyle(
              color: mainColor,
            ),
          ),
          elevation: 0,
          backgroundColor: additionalColor,
        ),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1.0,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 5,
            mainAxisExtent: 230,
          ),
          itemCount: artistsList.length,
          itemBuilder: (context, index) {
            final artist = artistsList[index];
            albumList.clear();
            artist
                .where((element) => albumList.add(element.audio.metas.album!))
                .toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  BlocProvider.of<AudioPlayerBloc>(context)
                      .add(InitializeAudioPlayerEvent(artist));
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ArtistListView(
                        artist: artist,
                      )));
                },
                splashColor: mainColor,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: mainColor.withAlpha(60),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Card(
                      color: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                artist[0].audio.metas.image!.path.isNotEmpty
                                    ? artist[0].audio.metas.image!.path
                                    : artist[0]
                                        .audio
                                        .metas
                                        .onImageLoadFail!
                                        .path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artist[0].audio.metas.artist!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: mainColor.withAlpha(180)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Albums: ' + albumList.join(' ,'),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: mainColor.withAlpha(130)),
                                    ),
                                    Text(
                                      'Tracks: ' + artist.length.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: mainColor.withAlpha(130)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            );
          }),
    );
  }
}
