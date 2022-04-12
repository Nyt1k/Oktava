import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:equatable/equatable.dart';

class AudioPlayerModel extends Equatable {
  final String id;
  final Audio audio;
  final bool isPlaying;

  const AudioPlayerModel(
      {required this.id, required this.audio, required this.isPlaying});

  @override
  List<Object?> get props => [id, isPlaying];

  @override
  bool get stringify => true;

  AudioPlayerModel copyWithIsPlaying(bool isPlaying) {
    return AudioPlayerModel(id: id, audio: audio, isPlaying: isPlaying);
  }
}
