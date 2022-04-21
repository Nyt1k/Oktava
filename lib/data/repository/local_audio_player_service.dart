import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/data/repository/audio_player_provider.dart';

class LocalAudioPlayerService implements AudioPlayerProvider {
  final List<AudioPlayerModel> audioPlayerModels;

  LocalAudioPlayerService({
    required this.audioPlayerModels,
  });

  @override
  Future<List<AudioPlayerModel>> getAll() async {
    return Future.value(audioPlayerModels);
  }

  @override
  Future<AudioPlayerModel> getById(String audioPlayerId) {
    return Future.value(
      audioPlayerModels.firstWhere((model) => model.id == audioPlayerId),
    );
  }

  @override
  Future<List<AudioPlayerModel>> updateAllModels(
      List<AudioPlayerModel> updateList) {
    audioPlayerModels.clear();
    audioPlayerModels.addAll(updateList);
    return Future.value(audioPlayerModels);
  }

  @override
  Future<List<AudioPlayerModel>> updateModel(AudioPlayerModel updateModel) {
    audioPlayerModels[audioPlayerModels.indexWhere(
      (element) => element.id == updateModel.id,
    )] = updateModel;
    return Future.value(audioPlayerModels);
  }
}
