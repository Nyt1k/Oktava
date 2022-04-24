import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String? userName;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.userName,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
      id: user.uid,
      email: user.email!,
      isEmailVerified: user.emailVerified,
      userName: null);

  AuthUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        email = snapshot.data()['email'],
        isEmailVerified = snapshot.data()['isEmailVerified'],
        userName = snapshot.data()['userName'];
}
