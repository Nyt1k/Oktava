import 'package:oktava/data/model/audio_player_model.dart';

abstract class AudioPlayerProvider {
  Future<void> init(List<AudioPlayerModel>? list);
  Future<AudioPlayerModel> getById(String audioPlayerId);
  Future<List<AudioPlayerModel>> getAll();

  Future<List<AudioPlayerModel>> updateModel(AudioPlayerModel updateModel);
  Future<List<AudioPlayerModel>> updateAllModels(
      List<AudioPlayerModel> updateList);
  Future<void> updateStatistics(String songId);
}
