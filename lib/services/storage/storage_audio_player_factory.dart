import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oktava/data/model/audio_player_model.dart';
import 'package:oktava/services/auth/auth_user.dart';
import 'package:oktava/services/auth/firebase_auth_provider.dart';

class StorageAudioPlayerFactory {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<List<AudioPlayerModel>> getUserModelsFromStorage(String userId) async {
    final snapshot = await _db
        .collection('songs')
        .where("song_owner", isEqualTo: userId)
        .get();

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

  Future<void> deleteModelFromStorage(
      String docId, String songUrl, String imageUrl) async {
    await _storage.refFromURL(songUrl).delete();
    await _storage.refFromURL(imageUrl).delete();
    await _db.collection('songs').doc(docId).delete();
  }

  Future<void> updateSongPlays(String songId) async{
    await _db
            .collection('songs')
            .doc(songId)
            .update({'song_plays': FieldValue.increment(1)});
  }
}
