import 'package:equatable/equatable.dart';
import 'package:oktava/data/model/audio_player_model.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();
}

class InitializeAudioPlayerEvent extends AudioPlayerEvent {
  const InitializeAudioPlayerEvent();

  @override
  List<Object> get props => [];
}

class TriggeredPlayAudioPlayerEvent extends AudioPlayerEvent {
  final AudioPlayerModel audioPlayerModel;

  const TriggeredPlayAudioPlayerEvent(this.audioPlayerModel);

  @override
  List<Object> get props => [audioPlayerModel];
}

class TriggeredPauseAudioPlayerEvent extends AudioPlayerEvent {
  final AudioPlayerModel audioPlayerModel;

  const TriggeredPauseAudioPlayerEvent(this.audioPlayerModel);

  @override
  List<Object> get props => [audioPlayerModel];
}

class AudioPlayedAudioPlayerEvent extends AudioPlayerEvent {
  final String? audioModelMetaId;

  const AudioPlayedAudioPlayerEvent(this.audioModelMetaId);

  @override
  List<Object?> get props => [audioModelMetaId];
}

class AudioPausedAudioPlayerEvent extends AudioPlayerEvent {
  final String? audioModelMetaId;

  const AudioPausedAudioPlayerEvent(this.audioModelMetaId);

  @override
  List<Object?> get props => [audioModelMetaId];
}

class AudioStoppedAudioPlayerEvent extends AudioPlayerEvent {
  const AudioStoppedAudioPlayerEvent();

  @override
  List<Object> get props => [];
}
