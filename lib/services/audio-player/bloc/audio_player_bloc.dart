import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/data/repository/audio_player_repository.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AssetsAudioPlayer assetsAudioPlayer;
  final AudioPlayerRepository audioPlayerRepository;

  List<StreamSubscription> playerSubscriptions = [];

  AudioPlayerBloc({
    required this.assetsAudioPlayer,
    required this.audioPlayerRepository,
    required AudioPlayerState initialState,
  }) : super(initialState) {
    playerSubscriptions.add(
      assetsAudioPlayer.playerState.listen(
        (event) {
          _mapPlayerStateToEvent(event);
        },
      ),
    );
  }

  Stream<AudioPlayerState> mapEventToState(AudioPlayerEvent event) async* {
    if (event is InitializeAudioPlayerEvent) {
      final audioList = await audioPlayerRepository.getAll();
      yield AudioPlayerReadyState(audioList);
    }

    if (event is AudioPlayedAudioPlayerEvent) {
      yield* _mapAudioPlayedToState(event);
    }

    if (event is AudioPausedAudioPlayerEvent) {
      yield* _mapAudioPausedToState(event);
    }

    if (event is AudioStoppedAudioPlayerEvent) {
      yield* _mapAudioStoppedToState();
    }

    if (event is TriggeredPlayAudioPlayerEvent) {
      yield* _mapTriggeredPlayAudio(event);
    }

    if (event is TriggeredPauseAudioPlayerEvent) {
      yield* _mapTriggeredPausedAudio(event);
    }
  }

  @override
  Future<void> close() async {
    for (var element in playerSubscriptions) {
      element.cancel();
    }
    return assetsAudioPlayer.dispose();
  }

  void _mapPlayerStateToEvent(PlayerState playerState) {
    if (playerState == PlayerState.stop) {
      add(const AudioStoppedAudioPlayerEvent());
    } else if (playerState == PlayerState.pause) {
      add(AudioPausedAudioPlayerEvent(
          assetsAudioPlayer.current.value?.audio.audio.metas.id));
    } else if (playerState == PlayerState.stop) {
      add(AudioPlayedAudioPlayerEvent(
          assetsAudioPlayer.current.value?.audio.audio.metas.id));
    }
  }

  Stream<AudioPlayerState> _mapAudioPlayedToState(
      AudioPlayedAudioPlayerEvent event) async* {
    final List<AudioPlayerModel> currentList =
        await audioPlayerRepository.getAll();

    final List<AudioPlayerModel> updatedList = currentList
        .map((audioModel) => audioModel.audio.metas.id == event.audioModelMetaId
            ? audioModel.copyWithIsPlaying(true)
            : audioModel.copyWithIsPlaying(false))
        .toList();

    await audioPlayerRepository.updateAllModels(updatedList);
    final AudioPlayerModel currentlyPlaying = updatedList.firstWhere(
        (element) => element.audio.metas.id == event.audioModelMetaId);
    yield AudioPlayerPlayingState(updatedList, currentlyPlaying);
  }

  Stream<AudioPlayerState> _mapAudioPausedToState(
      AudioPausedAudioPlayerEvent event) async* {
    final List<AudioPlayerModel> currentList =
        await audioPlayerRepository.getAll();

    final List<AudioPlayerModel> updatedList = currentList
        .map((audioModel) => audioModel.audio.metas.id == event.audioModelMetaId
            ? audioModel.copyWithIsPlaying(false)
            : audioModel)
        .toList();

    await audioPlayerRepository.updateAllModels(updatedList);
    final AudioPlayerModel currentlyPaused = currentList.firstWhere(
        (element) => element.audio.metas.id == event.audioModelMetaId);
    yield AudioPlayerPausedState(updatedList, currentlyPaused);
  }

  Stream<AudioPlayerState> _mapAudioStoppedToState() async* {
    final List<AudioPlayerModel> currentList =
        await audioPlayerRepository.getAll();
    final List<AudioPlayerModel> updatedList = currentList
        .map((audioModel) => audioModel.isPlaying
            ? audioModel.copyWithIsPlaying(false)
            : audioModel)
        .toList();
    yield AudioPlayerReadyState(updatedList);
    audioPlayerRepository.updateAllModels(updatedList);
  }

  Stream<AudioPlayerState> _mapTriggeredPlayAudio(
      TriggeredPlayAudioPlayerEvent event) async* {
    if (state is AudioPlayerReadyState) {
      final AudioPlayerModel updatedModel =
          event.audioPlayerModel.copyWithIsPlaying(true);
      final updatedList = await audioPlayerRepository.updateModel(updatedModel);

      await assetsAudioPlayer.open(
        updatedModel.audio,
        showNotification: true,
      );
      yield AudioPlayerPlayingState(updatedList, updatedModel);
    }

    if (state is AudioPlayerPausedState) {
      if (event.audioPlayerModel.id ==
          (state as AudioPlayerPausedState).pausedEntity.id) {
        final AudioPlayerModel updatedModel =
            event.audioPlayerModel.copyWithIsPlaying(true);
        final updatedList =
            await audioPlayerRepository.updateModel(updatedModel);

        await assetsAudioPlayer.play();

        yield AudioPlayerPlayingState(updatedList, updatedModel);
      } else {
        final AudioPlayerModel updatedModel =
            event.audioPlayerModel.copyWithIsPlaying(true);
        final updatedList =
            await audioPlayerRepository.updateModel(updatedModel);

        await assetsAudioPlayer.open(
          updatedModel.audio,
          showNotification: true,
          respectSilentMode: true,
          headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        );

        yield AudioPlayerPlayingState(updatedList, updatedModel);
      }
    }

    if (state is AudioPlayerPlayingState) {
      final AudioPlayerModel updatedModel =
          event.audioPlayerModel.copyWithIsPlaying(true);
      final updatedList = await audioPlayerRepository.updateModel(updatedModel);

      await assetsAudioPlayer.open(
        updatedModel.audio,
        showNotification: true,
      );

      yield AudioPlayerPlayingState(updatedList, updatedModel);
    }
  }

  Stream<AudioPlayerState> _mapTriggeredPausedAudio(
      TriggeredPauseAudioPlayerEvent event) async* {
    final AudioPlayerModel updatedModel =
        event.audioPlayerModel.copyWithIsPlaying(false);
    final updatedList = await audioPlayerRepository.updateModel(updatedModel);

    await assetsAudioPlayer.pause();

    yield AudioPlayerPausedState(updatedList, updatedModel);
  }
}
