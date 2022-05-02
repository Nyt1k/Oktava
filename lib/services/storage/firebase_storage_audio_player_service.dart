import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/data/repository/audio_player_provider.dart';

class FirebaseStorageAudioPlayerService implements AudioPlayerProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late List<AudioPlayerModel> audioPlayerModels;

  @override
  Future<void> init() async {
    final snapshot = await _db.collection('songs').get();
    audioPlayerModels = snapshot.docs
        .map((snap) => AudioPlayerModel.fromDocumentSnapshot(snap))
        .toList();
  }

  @override
  Future<List<AudioPlayerModel>> getAll() async {
    return Future.value(audioPlayerModels);
  }

  @override
  Future<AudioPlayerModel> getById(String audioPlayerId) async {
    return Future.value(
      audioPlayerModels.firstWhere((model) => model.id == audioPlayerId),
    );
  }

  @override
  Future<List<AudioPlayerModel>> updateAllModels(
      List<AudioPlayerModel> updateList) async {
    audioPlayerModels.clear();
    audioPlayerModels.addAll(updateList);
    return Future.value(audioPlayerModels);
  }

  @override
  Future<List<AudioPlayerModel>> updateModel(
      AudioPlayerModel updateModel) async {
    audioPlayerModels[audioPlayerModels.indexWhere(
      (element) => element.id == updateModel.id,
    )] = updateModel;
    return Future.value(audioPlayerModels);
  }

  // late List<AudioPlayerModel> audioPlayerModels;

  // Future init() async {
  //   audioPlayerModels =
  //       await StorageAudioPlayerFactory().getModelsFromStorage();
  // }

  // @override
  // Future<List<AudioPlayerModel>> getAll() async {
  //   return Future.value(audioPlayerModels);
  // }

  // @override
  // Future<AudioPlayerModel> getById(String audioPlayerId) {
  //   return Future.value(
  //     audioPlayerModels.firstWhere((model) => model.id == audioPlayerId),
  //   );
  // }

  // @override
  // Future<List<AudioPlayerModel>> updateAllModels(
  //     List<AudioPlayerModel> updateList) {
  //   audioPlayerModels.clear();
  //   audioPlayerModels.addAll(updateList);
  //   return Future.value(audioPlayerModels);
  // }

  // @override
  // Future<List<AudioPlayerModel>> updateModel(AudioPlayerModel updateModel) {
  //   audioPlayerModels[audioPlayerModels.indexWhere(
  //     (element) => element.id == updateModel.id,
  //   )] = updateModel;
  //   return Future.value(audioPlayerModels);
  // }
}
