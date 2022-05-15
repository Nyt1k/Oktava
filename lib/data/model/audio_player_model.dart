import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:oktava/utilities/constants/photo_constants.dart';

class AudioPlayerModel extends Equatable {
  final String id;
  final Audio audio;
  final bool isPlaying;
  String? songUrl;
  String? songImage;
  String? songTags;
  String? songText;
  int likes;
  int plays;

  AudioPlayerModel(
      {this.songUrl,
      this.songImage,
      this.songTags,
      this.songText,
      this.likes = 0,
      this.plays = 0,
      required this.id,
      required this.audio,
      required this.isPlaying});

  @override
  List<Object?> get props => [id, isPlaying];

  @override
  bool get stringify => true;

  AudioPlayerModel copyWithIsPlaying(bool isPlaying) {
    return AudioPlayerModel(
        id: id,
        audio: audio,
        isPlaying: isPlaying,
        likes: likes,
        plays: plays,
        songTags: songTags,
        songText: songText,);
  }

  factory AudioPlayerModel.fromDocumentSnapshot(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      AudioPlayerModel(
        id: snapshot.id,
        audio: Audio(
          snapshot.data()!['song_url'],
          metas: Metas(
            id: snapshot.id,
            title: snapshot.data()!['song_name'],
            artist: snapshot.data()!['song_owner'],
            album: snapshot.data()!['song_album'],
            image: MetasImage.network(snapshot.data()!['song_image']),
            onImageLoadFail: const MetasImage.network(defaultSongImage),
          ),
        ),
        isPlaying: false,
        songTags: snapshot.data()!['song_tags'],
        songText: snapshot.data()!['song_text'],
        likes: snapshot.data()!['song_likes'],
        plays: snapshot.data()!['song_plays'],
      );
}
