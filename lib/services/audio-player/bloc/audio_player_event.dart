import 'package:flutter/material.dart';
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
  final BuildContext context;

  const TriggeredPlayAudioPlayerEvent(this.audioPlayerModel, this.context);
}

class TriggeredPauseAudioPlayerEvent extends AudioPlayerEvent {
  final AudioPlayerModel audioPlayerModel;

  const TriggeredPauseAudioPlayerEvent(this.audioPlayerModel);
}

class TriggeredNextAudioPlayerEvent extends AudioPlayerEvent {
  final AudioPlayerModel audioPlayerModel;

  const TriggeredNextAudioPlayerEvent(this.audioPlayerModel);
}

class TriggeredPrevAudioPlayerEvent extends AudioPlayerEvent {
  final AudioPlayerModel audioPlayerModel;

  const TriggeredPrevAudioPlayerEvent(this.audioPlayerModel);
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
