import 'package:flutter/material.dart';
import 'package:oktava/data/model/audio_player_model.dart';

class AlbumListView extends StatefulWidget {
  final List<AudioPlayerModel> album;
  const AlbumListView({Key? key,required this.album}) : super(key: key);

  @override
  State<AlbumListView> createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
