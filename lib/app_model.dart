import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/core/repository/setting_repository.dart';
import 'package:league_of_legends_library/data/impl_champion_local_data_source.dart';
import 'package:league_of_legends_library/data/server.dart';
import 'package:league_of_legends_library/data/setting_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel {
  ChampionRepository championRepository;
  SettingRepository settingRepository;

  AppModel._(
      {required this.championRepository, required this.settingRepository});

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
    );
  }
}
