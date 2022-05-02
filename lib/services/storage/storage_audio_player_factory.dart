import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';

class StorageAudioPlayerFactory {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<AudioPlayerModel>> getModelsFromStorage() async {
    final snapshot = await _db.collection('songs').get();
    final list = snapshot.docs
        .map((snap) => AudioPlayerModel.fromDocumentSnapshot(snap))
        .toList();

    for (var element in list) {
      AuthUser user = await FirebaseAuthProvider()
          .getAlreadyAuthUser(userId: element.audio.metas.artist!);
      element.audio.updateMetas(artist: user.userName);
    }

    return list;
  }
}
