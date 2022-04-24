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
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.userName,
    this.userProfileImage,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );

  factory AuthUser.fromSnapshot(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      AuthUser(
        id: snapshot.id,
        email: snapshot.data()!['email'],
        isEmailVerified: snapshot.data()!['isVerified'],
        userName: snapshot.data()!['userName'],
        userProfileImage: snapshot.data()?['userProfileImage'],
      );
}
