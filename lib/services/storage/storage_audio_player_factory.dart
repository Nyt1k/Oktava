import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oktava/data/model/audio_player_model.dart';

class StorageAudioPlayerFactory  {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

   Future<List<AudioPlayerModel>> getModelsFromStorage() async {
    final snapshot = await _db.collection('songs').get();
    return snapshot.docs
        .map((snap) => AudioPlayerModel.fromDocumentSnapshot(snap))
        .toList();
  }
}
