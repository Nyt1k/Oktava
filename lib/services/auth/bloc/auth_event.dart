
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(this.email, this.password);
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  String? userName;

  AuthEventRegister(this.email, this.password, this.userName);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;

  const AuthEventForgotPassword({this.email});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventGetUser extends AuthEvent {
  final String userId;

  AuthEventGetUser(this.userId);
}

class AuthEventUpdateUser extends AuthEvent {
  final String userId;
  final String? userName;
  final String? userProfileImage;

  AuthEventUpdateUser(this.userName, this.userProfileImage, this.userId);
}
