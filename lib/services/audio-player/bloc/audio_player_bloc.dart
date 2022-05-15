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
          if (assetsAudioPlayer.currentLoopMode == LoopMode.none) {
            final List<AudioPlayerModel> currentList =
                await audioPlayerProvider.getAll();
            if (currentList
                .where((element) => element.isPlaying == true)
                .isNotEmpty) {
              AudioPlayerModel currentlyPlaying = currentList
                  .firstWhere((element) => element.isPlaying == true);

              add(TriggeredNextAudioPlayerEvent(currentlyPlaying));
              add(AudioPlayedStatisticsAudioPlayerEvent(
                  audioPlayerModel: currentlyPlaying));
            }
          }
        },
      ),
    );

    on<AudioPlayedStatisticsAudioPlayerEvent>(
      (event, emit) async {
        await audioPlayerProvider.updateStatistics(event.audioPlayerModel.id);
      },
    );

    on<AudioItemsRefreshAudioPlayerEvent>(
      (event, emit) async {
        emit(AudioPlayerItemsRefreshingState());
        await audioPlayerProvider
            .getAll()
            .whenComplete(() => {null})
            .then((value) => {emit(const AudioPlayerInitialState())});
      },
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
        } else {
          await audioPlayerProvider.init(event.list);
          await audioPlayerProvider
              .getAll()
              .whenComplete(() => {null})
              .then((value) => {emit(AudioPlayerReadyState(value))});
        }
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
            Playlist(audios: [
              Audio.network(updatedModel.audio.path,
                  metas: updatedModel.audio.metas)
            ]),
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
              Playlist(audios: [
                Audio.network(updatedModel.audio.path,
                    metas: updatedModel.audio.metas)
              ]),
              showNotification: true,
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
            Playlist(audios: [
              Audio.network(updatedModel.audio.path,
                  metas: updatedModel.audio.metas)
            ]),
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
          Playlist(audios: [
            Audio.network(currentList[index - 1].audio.path,
                metas: updatedModel.audio.metas)
          ]),
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
          Playlist(audios: [
            Audio.network(currentList[index + 1].audio.path,
                metas: updatedModel.audio.metas)
          ]),
          showNotification: true,
        );

        emit(AudioPlayerPlayingState(updatedNewList, updatedModel));
      },
    );
  }
}
