import 'package:oktava/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser(
      {required String email,
      required String password,
      String? userName,
      String? userProfileImage});

  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
  Future<AuthUser> getAlreadyAuthUser({required String userId});
  Future<void> updateAuthUSer({
    required String userId,
    String? userName,
    bool? isVerified,
    String? userProfileImage,
  });
}
