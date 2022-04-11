// login exceptions
class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

// register exceptions
class WeekPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exception
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}