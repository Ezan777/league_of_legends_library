abstract class AuthSource {
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<String?> singUp(String email, String password);
  Future<void> sendPasswordReset(String email);
  Future<void> deleteUser(String email, String password);
  Future<bool> checkCredentials(String email, String password);
  Future<void> changePassword(String newPassword);
}

class InvalidCredentials implements Exception {}

class EmailAlreadyInUse implements Exception {}

class WeakPassword implements Exception {}

class InvalidEmailAddress implements Exception {}
