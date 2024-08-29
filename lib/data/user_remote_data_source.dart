import 'package:league_of_legends_library/core/model/app_user.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> getUserData(String userId);
  Future<void> saveUserData(AppUser user);
  Future<void> deleteUserData(AppUser user);
}

class UserNotFound implements Exception {}
