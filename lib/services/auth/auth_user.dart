import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String? userName;
  final String? userProfileImage;
  final List<String?>? userFavorites;
  final List<List<String>>? userPlaylists;
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
    var doc = snapshot.data()?['userFavorites'];
    if (doc != null) {
      for (var element in doc) {
        list.add(element.toString());
      }
    }

    return AuthUser(
      id: snapshot.id,
      email: snapshot.data()!['email'],
      isEmailVerified: snapshot.data()!['isVerified'],
      userName: snapshot.data()!['userName'],
      userProfileImage: snapshot.data()?['userProfileImage'],
      userFavorites: list,
    );
  }
}
