import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:oktava/data/model/playlist_model.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String? userName;
  final String? userProfileImage;
  final List<String?>? userFavorites;
  final List<PlaylistModels?>? userPlaylists;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.userName,
    this.userProfileImage,
    this.userFavorites,
    this.userPlaylists,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );

  factory AuthUser.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<String?>? list = [];
    List<PlaylistModels?>? userPlaylists = [];
    var doc = snapshot.data()?['userFavorites'];
    if (doc != null) {
      for (var element in doc) {
        list.add(element.toString());
      }
    }

    var map = snapshot.data()?['userPlaylists'];
    if (map != null) {
      var item = Map<String, dynamic>.from(map);
      item.forEach((key, value) {
        List<String?>? songs = List.castFrom(value);
        PlaylistModels? model = PlaylistModels(id: key, playlistSongs: songs);
        userPlaylists.add(model);
      });
    }

    return AuthUser(
      id: snapshot.id,
      email: snapshot.data()!['email'],
      isEmailVerified: snapshot.data()!['isVerified'],
      userName: snapshot.data()!['userName'],
      userProfileImage: snapshot.data()?['userProfileImage'],
      userFavorites: list,
      userPlaylists: userPlaylists,
    );
  }
}
