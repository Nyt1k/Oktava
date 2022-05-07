import 'package:flutter/material.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/main.dart';
import 'package:oktava/utilities/constants/color_constants.dart';
import 'package:oktava/views/album_list_view.dart';

class AlbumsView extends StatefulWidget {
  final List<AudioPlayerModel> models;
  const AlbumsView({Key? key, required this.models}) : super(key: key);

  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  List<List<AudioPlayerModel>> albumsList = [];

  @override
  void initState() {
    var seen = <String>{};
    final uniqueNames = widget.models
        .where((element) => seen.add(element.audio.metas.album!))
        .toList();

    for (var uniqueName in seen) {
      List<AudioPlayerModel> list = [];
      for (var model in widget.models) {
        if (model.audio.metas.album == uniqueName) {
          list.add(model);
        }
      }
      albumsList.add(list);
    }
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
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
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
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 5,
            mainAxisExtent: 200,
          ),
          itemCount: albumsList.length,
          itemBuilder: (context, index) {
            final album = albumsList[index];
            return InkWell(
              onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AlbumListView(album: album,)));
              },
              splashColor: mainColor,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withAlpha(20),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Card(
                  color: secondaryColor,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                            child: Image.network(
                              album[0].audio.metas.image!.path.isNotEmpty
                                  ? album[0].audio.metas.image!.path
                                  : album[0].audio.metas.onImageLoadFail!.path,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                album[0].audio.metas.album!,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: mainColor.withAlpha(180)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    album[0].audio.metas.artist!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: mainColor.withAlpha(130)),
                                  ),
                                  Text(
                                    'Tracks: ' + album.length.toString(),
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
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
