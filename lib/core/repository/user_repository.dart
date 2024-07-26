import 'dart:developer';

import 'package:league_of_legends_library/core/model/app_user.dart';
import 'package:league_of_legends_library/data/user_local_data_source.dart';
import 'package:league_of_legends_library/data/user_remote_data_source.dart';

class UserRepository {
  final UserLocalDataSource _userLocalDataSource;
  final UserRemoteDataSource _userRemoteDataSource;

  const UserRepository(this._userLocalDataSource, this._userRemoteDataSource);

  Future<AppUser?> getCurrentlyLoggedUser() async {
    final userId = _userLocalDataSource.getCurrentlyLoggedUserId();
    if (userId != null) {
      log("USER ID: $userId");
      return await _getUserFromId(userId);
    }

    return null;
  }

  Future<void> saveUser(AppUser user) async {
    await _userRemoteDataSource.saveUserData(user);
  }

  Future<AppUser> _getUserFromId(String userId) async {
    final userData = await _userRemoteDataSource.getUserData(userId);
    return AppUser(
      id: userData["id"],
      email: userData["email"],
      summonerName: userData["summonerName"],
      tagLine: userData["tagLine"],
      serverCode: userData["serverCode"],
      name: userData["name"],
      surname: userData["surname"],
    );
  }
}
