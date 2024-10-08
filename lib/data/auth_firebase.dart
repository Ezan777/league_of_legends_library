import 'package:firebase_auth/firebase_auth.dart';
import 'package:league_of_legends_library/data/auth_source.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';

class AuthFirebase with RemoteDataSource implements AuthSource {
  @override
  Future<void> login(String email, String password) async {
    await checkConnection();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw InvalidCredentials();
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<String?> singUp(String email, String password) async {
    await checkConnection();
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user?.uid;
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await checkConnection();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        throw InvalidEmailAddress();
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> deleteUser(String email, String password) async {
    await checkConnection();
    final firebaseAuth = FirebaseAuth.instance;
    try {
      final credentials = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await credentials.user?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        throw InvalidCredentials();
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<bool> checkCredentials(String email, String password) async {
    await checkConnection();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        return false;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> changePassword(String newPassword) async {
    await checkConnection();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception("No user logged in");
    }
  }
}
