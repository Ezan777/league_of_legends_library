import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/data/impl_local_data_source.dart';
import 'package:league_of_legends_library/data/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel {
  ChampionRepository championRepository;

  AppModel._({required this.championRepository});

  static Future<AppModel> initializeDataSource() async {
    return AppModel._(
        championRepository: ChampionRepository(
            remoteDataSource: Server(),
            localDataSource: ImplLocalDataSource(
                sharedPreferences: await SharedPreferences.getInstance())));
  }
}
