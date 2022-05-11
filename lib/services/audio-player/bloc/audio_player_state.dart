import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:oktava/data/model/audio_player_model.dart';

@immutable
abstract class AudioPlayerState {
  const AudioPlayerState();
}

class AudioPlayerInitialState extends AudioPlayerState with EquatableMixin {
  const AudioPlayerInitialState();

  @override
  List<Object?> get props => [];
}

class AudioPlayerReadyState extends AudioPlayerState with EquatableMixin {
  final List<AudioPlayerModel> entityList;

  const AudioPlayerReadyState(this.entityList);

  @override
  List<Object?> get props => [entityList];
}

class AudioPlayerPlayingState extends AudioPlayerState with EquatableMixin {
  final AudioPlayerModel playingEntity;
  final List<AudioPlayerModel> entityList;

  const AudioPlayerPlayingState(this.entityList, this.playingEntity);

  @override
  List<Object?> get props => [playingEntity, entityList];
}

class AudioPlayerPausedState extends AudioPlayerState with EquatableMixin {
  final List<AudioPlayerModel> entityList;
  final AudioPlayerModel pausedEntity;

  const AudioPlayerPausedState(this.entityList, this.pausedEntity);

  @override
  List<Object?> get props => [pausedEntity];
}

class AudioPlayerFailureState extends AudioPlayerState with EquatableMixin {
  final String error;

  const AudioPlayerFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

class AudioPlayerItemsRefreshingState extends AudioPlayerState{}