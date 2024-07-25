import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/core/repository/setting_repository.dart';
import 'package:league_of_legends_library/core/repository/user_repository.dart';
import 'package:league_of_legends_library/data/auth_firebase.dart';
import 'package:league_of_legends_library/data/auth_source.dart';
import 'package:league_of_legends_library/data/firebase_local_user_data.dart';
import 'package:league_of_legends_library/data/firestore_user_data.dart';
import 'package:league_of_legends_library/data/impl_champion_local_data_source.dart';
import 'package:league_of_legends_library/data/server.dart';
import 'package:league_of_legends_library/data/setting_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel {
  ChampionRepository championRepository;
  SettingRepository settingRepository;
  UserRepository userRepository;
  AuthSource authSource;

  AppModel._(
      {required this.championRepository,
      required this.settingRepository,
      required this.userRepository,
      required this.authSource});

  static Future<AppModel> initializeDataSource() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return AppModel._(
      championRepository: ChampionRepository(
        remoteDataSource: Server(),
        localDataSource:
            ImplLocalDataSource(sharedPreferences: sharedPreferences),
      ),
      settingRepository: SettingRepository(
        SettingDataSource(sharedPreferences),
      ),
      userRepository:
          UserRepository(FirebaseLocalUserData(), FirestoreUserData()),
      authSource: AuthFirebase(),
    );
  }
}
