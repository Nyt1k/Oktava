import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/data/repository/audio_player_provider.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_event.dart';
import 'package:oktava/services/audio-player/bloc/audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AssetsAudioPlayer assetsAudioPlayer;
  final AudioPlayerProvider audioPlayerProvider;

  List<StreamSubscription> playerSubscriptions = [];

  AudioPlayerBloc({
    required this.assetsAudioPlayer,
    required this.audioPlayerProvider,
  }) : super(const AudioPlayerInitialState()) {
    playerSubscriptions.add(
      assetsAudioPlayer.playlistAudioFinished.listen(
        (event) async {
          final List<AudioPlayerModel> currentList =
              await audioPlayerProvider.getAll();
          if (currentList
              .where((element) => element.isPlaying == true)
              .isNotEmpty) {
            AudioPlayerModel currentlyPlaying =
                currentList.firstWhere((element) => element.isPlaying == true);

            add(TriggeredNextAudioPlayerEvent(currentlyPlaying));
          }
        },
      ),
    );

    on<InitializeAudioPlayerEvent>(
      (event, emit) async {
        if (state is AudioPlayerPlayingState) {
          final List<AudioPlayerModel> currentList =
              await audioPlayerProvider.getAll();
          AudioPlayerModel currentlyPlaying =
              currentList.firstWhere((element) => element.isPlaying == true);
          currentlyPlaying.copyWithIsPlaying(false);
          final List<AudioPlayerModel> updatedList = currentList
              .map((audioModel) =>
                  audioModel.audio.metas.id == currentlyPlaying.id
                      ? audioModel.copyWithIsPlaying(false)
                      : audioModel)
              .toList();
          await audioPlayerProvider.updateAllModels(updatedList);

          await assetsAudioPlayer.stop();
          emit(AudioPlayerReadyState(updatedList));
        }
        await audioPlayerProvider.init();
        final audioList = await audioPlayerProvider.getAll();
        emit(AudioPlayerReadyState(audioList));
      },
    );

    on<AudioPlayedAudioPlayerEvent>(
      (event, emit) async {
        final List<AudioPlayerModel> currentList =
            await audioPlayerProvider.getAll();
        final List<AudioPlayerModel> updatedList = currentList
            .map((audioModel) =>
                audioModel.audio.metas.id == event.audioModelMetaId
                    ? audioModel.copyWithIsPlaying(true)
                    : audioModel.copyWithIsPlaying(false))
            .toList();

        await audioPlayerProvider.updateAllModels(updatedList);
        final AudioPlayerModel currentlyPlaying = updatedList.firstWhere(
            (element) => element.audio.metas.id == event.audioModelMetaId);
        emit(AudioPlayerPausedState(updatedList, currentlyPlaying));
      },
    );

    on<AudioPausedAudioPlayerEvent>(
      (event, emit) async {
        final List<AudioPlayerModel> currentList =
            await audioPlayerProvider.getAll();

        final List<AudioPlayerModel> updatedList = currentList
            .map((audioModel) =>
                audioModel.audio.metas.id == event.audioModelMetaId
                    ? audioModel.copyWithIsPlaying(false)
                    : audioModel)
            .toList();

        await audioPlayerProvider.updateAllModels(updatedList);
        final AudioPlayerModel currentlyPaused = currentList.firstWhere(
            (element) => element.audio.metas.id == event.audioModelMetaId);
        emit(AudioPlayerPausedState(updatedList, currentlyPaused));
      },
    );

    on<AudioStoppedAudioPlayerEvent>(
      (event, emit) async {
        final List<AudioPlayerModel> currentList =
            await audioPlayerProvider.getAll();
        final List<AudioPlayerModel> updatedList = currentList
            .map((audioModel) => audioModel.isPlaying
                ? audioModel.copyWithIsPlaying(false)
                : audioModel)
            .toList();
        emit(AudioPlayerReadyState(updatedList));
        audioPlayerProvider.updateAllModels(updatedList);
      },
    );

    on<TriggeredPlayAudioPlayerEvent>(
      (event, emit) async {
        AudioPlayerModel updatedModel =
            event.audioPlayerModel.copyWithIsPlaying(true);
        if (state is AudioPlayerReadyState) {
          final updatedList =
              await audioPlayerProvider.updateModel(updatedModel);

          await assetsAudioPlayer.open(
            Audio.network(updatedModel.audio.path),
            showNotification: true,
          );

          emit(AudioPlayerPlayingState(updatedList, updatedModel));
        } else if (state is AudioPlayerPausedState) {
          if (event.audioPlayerModel.id ==
              (state as AudioPlayerPausedState).pausedEntity.id) {
            final updatedList =
                await audioPlayerProvider.updateModel(updatedModel);

            await assetsAudioPlayer.play();

            emit(AudioPlayerPlayingState(updatedList, updatedModel));
          } else {
            final updatedList =
                await audioPlayerProvider.updateModel(updatedModel);
            await assetsAudioPlayer.open(
              Audio.network(updatedModel.audio.path),
              showNotification: true,
              respectSilentMode: true,
              headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
            );

            emit(AudioPlayerPlayingState(updatedList, updatedModel));
          }
        } else if (state is AudioPlayerPlayingState) {
          final List<AudioPlayerModel> currentList =
              await audioPlayerProvider.getAll();
          AudioPlayerModel currentlyPlaying =
              currentList.firstWhere((element) => element.isPlaying == true);
          currentlyPlaying.copyWithIsPlaying(false);
          final List<AudioPlayerModel> updatedList = currentList
              .map((audioModel) =>
                  audioModel.audio.metas.id == currentlyPlaying.id
                      ? audioModel.copyWithIsPlaying(false)
                      : audioModel)
              .toList();
          await audioPlayerProvider.updateAllModels(updatedList);

          emit(AudioPlayerPausedState(updatedList, currentlyPlaying));

          updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
          final updatedNewList =
              await audioPlayerProvider.updateModel(updatedModel);
          await assetsAudioPlayer.open(
            Audio.network(updatedModel.audio.path),
            showNotification: true,
          );

          emit(AudioPlayerPlayingState(updatedNewList, updatedModel));
        }
      },
    );

    on<TriggeredPauseAudioPlayerEvent>(
      (event, emit) async {
        final AudioPlayerModel updatedModel =
            event.audioPlayerModel.copyWithIsPlaying(false);
        final updatedList = await audioPlayerProvider.updateModel(updatedModel);

        await assetsAudioPlayer.pause();

        emit(AudioPlayerPausedState(updatedList, updatedModel));
      },
    );

    on<TriggeredPrevAudioPlayerEvent>(
      (event, emit) async {
        int index = -1;
        final List<AudioPlayerModel> currentList =
            await audioPlayerProvider.getAll();
        if (state is AudioPlayerPlayingState) {
          final List<AudioPlayerModel> currentList =
              await audioPlayerProvider.getAll();
          AudioPlayerModel currentlyPlaying =
              currentList.firstWhere((element) => element.isPlaying == true);
          index =
              currentList.indexWhere((element) => element.isPlaying == true);
          currentlyPlaying.copyWithIsPlaying(false);
          final List<AudioPlayerModel> updatedList = currentList
              .map((audioModel) =>
                  audioModel.audio.metas.id == currentlyPlaying.id
                      ? audioModel.copyWithIsPlaying(false)
                      : audioModel)
              .toList();
          await audioPlayerProvider.updateAllModels(updatedList);

          emit(AudioPlayerPausedState(updatedList, currentlyPlaying));
        } else if (state is AudioPlayerPausedState) {
          if (event.audioPlayerModel.id ==
              (state as AudioPlayerPausedState).pausedEntity.id) {
            index = currentList.indexWhere(
                (element) => element.id == event.audioPlayerModel.id);
          }
        }

        if (index - 1 < 0) {
          index = currentList.length;
        }
        final AudioPlayerModel updatedModel =
            currentList[index - 1].copyWithIsPlaying(true);
        final updatedNewList =
            await audioPlayerProvider.updateModel(updatedModel);

        await assetsAudioPlayer.open(
          Audio.network(currentList[index - 1].audio.path),
          showNotification: true,
        );

        emit(AudioPlayerPlayingState(updatedNewList, updatedModel));
      },
    );

    on<TriggeredNextAudioPlayerEvent>(
      (event, emit) async {
        int index = -1;
        final List<AudioPlayerModel> currentList =
            await audioPlayerProvider.getAll();
        if (state is AudioPlayerPlayingState) {
          final List<AudioPlayerModel> currentList =
              await audioPlayerProvider.getAll();
          AudioPlayerModel currentlyPlaying =
              currentList.firstWhere((element) => element.isPlaying == true);
          index =
              currentList.indexWhere((element) => element.isPlaying == true);
          currentlyPlaying.copyWithIsPlaying(false);
          final List<AudioPlayerModel> updatedList = currentList
              .map((audioModel) =>
                  audioModel.audio.metas.id == currentlyPlaying.id
                      ? audioModel.copyWithIsPlaying(false)
                      : audioModel)
              .toList();
          await audioPlayerProvider.updateAllModels(updatedList);

          emit(AudioPlayerPausedState(updatedList, currentlyPlaying));
        } else if (state is AudioPlayerPausedState) {
          if (event.audioPlayerModel.id ==
              (state as AudioPlayerPausedState).pausedEntity.id) {
            index = currentList.indexWhere(
                (element) => element.id == event.audioPlayerModel.id);
          }
        }

        if (index + 1 >= currentList.length) {
          index = -1;
        }
        final AudioPlayerModel updatedModel =
            currentList[index + 1].copyWithIsPlaying(true);
        final updatedNewList =
            await audioPlayerProvider.updateModel(updatedModel);

        await assetsAudioPlayer.open(
          Audio.network(currentList[index + 1].audio.path),
          showNotification: true,
        );

        emit(AudioPlayerPlayingState(updatedNewList, updatedModel));
      },
    );
  }

  // Stream<AudioPlayerState> mapEventToState(AudioPlayerEvent event) async* {
  //   if (event is InitializeAudioPlayerEvent) {
  //     final audioList = await audioPlayerProvider.getAll();
  //     yield AudioPlayerReadyState(audioList);
  //   }

  //   if (event is AudioPlayedAudioPlayerEvent) {
  //     yield* _mapAudioPlayedToState(event);
  //   }

  //   if (event is AudioPausedAudioPlayerEvent) {
  //     yield* _mapAudioPausedToState(event);
  //   }

  //   if (event is AudioStoppedAudioPlayerEvent) {
  //     yield* _mapAudioStoppedToState();
  //   }

  //   if (event is TriggeredPlayAudioPlayerEvent) {
  //     yield* _mapTriggeredPlayAudio(event);
  //   }

  //   if (event is TriggeredPauseAudioPlayerEvent) {
  //     yield* _mapTriggeredPausedAudio(event);
  //   }
  // }

  // @override
  // Future<void> close() async {
  //   for (var element in playerSubscriptions) {
  //     element.cancel();
  //   }
  //   return assetsAudioPlayer.dispose();
  // }

  // void _mapPlayerStateToEvent(PlayerState playerState) {
  //   if (playerState == PlayerState.stop) {
  //     add(const AudioStoppedAudioPlayerEvent());
  //   } else if (playerState == PlayerState.pause) {
  //     add(AudioPausedAudioPlayerEvent(
  //         assetsAudioPlayer.current.value?.audio.audio.metas.id));
  //   } else if (playerState == PlayerState.play) {
  //     add(AudioPlayedAudioPlayerEvent(
  //         assetsAudioPlayer.current.value?.audio.audio.metas.id));
  //   }
  // }

  // Stream<AudioPlayerState> _mapAudioPlayedToState(
  //     AudioPlayedAudioPlayerEvent event) async* {
  //   final List<AudioPlayerModel> currentList =
  //       await audioPlayerProvider.getAll();

  //   final List<AudioPlayerModel> updatedList = currentList
  //       .map((audioModel) => audioModel.audio.metas.id == event.audioModelMetaId
  //           ? audioModel.copyWithIsPlaying(true)
  //           : audioModel.copyWithIsPlaying(false))
  //       .toList();

  //   await audioPlayerProvider.updateAllModels(updatedList);
  //   final AudioPlayerModel currentlyPlaying = updatedList.firstWhere(
  //       (element) => element.audio.metas.id == event.audioModelMetaId);
  //   yield AudioPlayerPlayingState(updatedList, currentlyPlaying);
  // }

  // Stream<AudioPlayerState> _mapAudioPausedToState(
  //     AudioPausedAudioPlayerEvent event) async* {
  //   final List<AudioPlayerModel> currentList =
  //       await audioPlayerProvider.getAll();

  //   final List<AudioPlayerModel> updatedList = currentList
  //       .map((audioModel) => audioModel.audio.metas.id == event.audioModelMetaId
  //           ? audioModel.copyWithIsPlaying(false)
  //           : audioModel)
  //       .toList();

  //   await audioPlayerProvider.updateAllModels(updatedList);
  //   final AudioPlayerModel currentlyPaused = currentList.firstWhere(
  //       (element) => element.audio.metas.id == event.audioModelMetaId);
  //   yield AudioPlayerPausedState(updatedList, currentlyPaused);
  // }

  // Stream<AudioPlayerState> _mapAudioStoppedToState() async* {
  //   final List<AudioPlayerModel> currentList =
  //       await audioPlayerProvider.getAll();
  //   final List<AudioPlayerModel> updatedList = currentList
  //       .map((audioModel) => audioModel.isPlaying
  //           ? audioModel.copyWithIsPlaying(false)
  //           : audioModel)
  //       .toList();
  //   yield AudioPlayerReadyState(updatedList);
  //   audioPlayerProvider.updateAllModels(updatedList);
  // }

  // Stream<AudioPlayerState> _mapTriggeredPlayAudio(
  //     TriggeredPlayAudioPlayerEvent event) async* {
  //   if (state is AudioPlayerReadyState) {
  //     final AudioPlayerModel updatedModel =
  //         event.audioPlayerModel.copyWithIsPlaying(true);
  //     final updatedList = await audioPlayerProvider.updateModel(updatedModel);

  //     await assetsAudioPlayer.open(
  //       updatedModel.audio,
  //       showNotification: true,
  //     );
  //     yield AudioPlayerPlayingState(updatedList, updatedModel);
  //   }

  //   if (state is AudioPlayerPausedState) {
  //     if (event.audioPlayerModel.id ==
  //         (state as AudioPlayerPausedState).pausedEntity.id) {
  //       final AudioPlayerModel updatedModel =
  //           event.audioPlayerModel.copyWithIsPlaying(true);
  //       final updatedList = await audioPlayerProvider.updateModel(updatedModel);

  //       await assetsAudioPlayer.play();

  //       yield AudioPlayerPlayingState(updatedList, updatedModel);
  //     } else {
  //       final AudioPlayerModel updatedModel =
  //           event.audioPlayerModel.copyWithIsPlaying(true);
  //       final updatedList = await audioPlayerProvider.updateModel(updatedModel);

  //       await assetsAudioPlayer.open(
  //         updatedModel.audio,
  //         showNotification: true,
  //         respectSilentMode: true,
  //         headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
  //       );

  //       yield AudioPlayerPlayingState(updatedList, updatedModel);
  //     }
  //   }

  //   if (state is AudioPlayerPlayingState) {
  //     final AudioPlayerModel updatedModel =
  //         event.audioPlayerModel.copyWithIsPlaying(true);
  //     final updatedList = await audioPlayerProvider.updateModel(updatedModel);

  //     await assetsAudioPlayer.open(
  //       updatedModel.audio,
  //       showNotification: true,
  //     );

  //     yield AudioPlayerPlayingState(updatedList, updatedModel);
  //   }
  // }

  // Stream<AudioPlayerState> _mapTriggeredPausedAudio(
  //     TriggeredPauseAudioPlayerEvent event) async* {
  //   final AudioPlayerModel updatedModel =
  //       event.audioPlayerModel.copyWithIsPlaying(false);
  //   final updatedList = await audioPlayerProvider.updateModel(updatedModel);

  //   await assetsAudioPlayer.pause();

  //   yield AudioPlayerPausedState(updatedList, updatedModel);
  // }
}
