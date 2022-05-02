import 'package:oktava/data/model/audio_player_model.dart';

abstract class AudioPlayerProvider {
  Future<void> init();
  Future<AudioPlayerModel> getById(String audioPlayerId);
  Future<List<AudioPlayerModel>> getAll();

  Future<List<AudioPlayerModel>> updateModel(AudioPlayerModel updateModel);
  Future<List<AudioPlayerModel>> updateAllModels(
      List<AudioPlayerModel> updateList);
}
