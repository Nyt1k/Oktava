import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktava/data/model/audio_player_model.dart';

@immutable
abstract class AudioPlayerEvent {
  const AudioPlayerEvent();
}

class InitializeAudioPlayerEvent extends AudioPlayerEvent {
  const InitializeAudioPlayerEvent();
}

class TriggeredPlayAudioPlayerEvent extends AudioPlayerEvent {
  final AudioPlayerModel audioPlayerModel;

  const TriggeredPlayAudioPlayerEvent(this.audioPlayerModel);
}

class TriggeredPauseAudioPlayerEvent extends AudioPlayerEvent {
  final AudioPlayerModel audioPlayerModel;

  const TriggeredPauseAudioPlayerEvent(this.audioPlayerModel);
}

class AudioPlayedAudioPlayerEvent extends AudioPlayerEvent {
  final String? audioModelMetaId;

  const AudioPlayedAudioPlayerEvent(String? id, {this.audioModelMetaId});
}

class AudioPausedAudioPlayerEvent extends AudioPlayerEvent {
  final String? audioModelMetaId;

  const AudioPausedAudioPlayerEvent(String? id, {this.audioModelMetaId});
}

class AudioStoppedAudioPlayerEvent extends AudioPlayerEvent {
  const AudioStoppedAudioPlayerEvent();
}
