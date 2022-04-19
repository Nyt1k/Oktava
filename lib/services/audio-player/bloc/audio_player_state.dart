import 'package:equatable/equatable.dart';
import 'package:oktava/data/model/audio_player_model.dart';

abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();
}

class AudioPlayerInitialState extends AudioPlayerState {
  const AudioPlayerInitialState();

  @override
  List<Object?> get props => [];
}

class AudioPlayerReadyState extends AudioPlayerState {
  final List<AudioPlayerModel> entityList;

  const AudioPlayerReadyState(this.entityList);

  @override
  List<Object?> get props => [entityList];
}

class AudioPlayerPlayingState extends AudioPlayerState {
  final AudioPlayerModel playingEntity;
  final List<AudioPlayerModel> entityList;

  const AudioPlayerPlayingState(this.entityList, this.playingEntity);

  @override
  List<Object?> get props => [playingEntity, entityList];
}

class AudioPlayerPausedState extends AudioPlayerState {
  final List<AudioPlayerModel> entityList;
  final AudioPlayerModel pausedEntity;

  const AudioPlayerPausedState(this.entityList, this.pausedEntity);

  @override
  List<Object?> get props => [pausedEntity];
}

class AudioPlayerFailureState extends AudioPlayerState {
  final String error;

  const AudioPlayerFailureState(this.error);

  @override
  List<Object?> get props => [error];
}
