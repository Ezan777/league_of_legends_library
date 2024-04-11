import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';

class ChampionRepository {
  final RemoteDataSource _remoteDataSource;
  final String _baseUrl = "https://dragontail.enricozangrando.com";
  final String _championDataPath =
      "14.7.1/data/en_US/champion";

  ChampionRepository({
    required RemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Return the champion with the given [championId].
  Future<Champion> getChampionById({required String championId}) async {
    final json = await _remoteDataSource
        .fetchJson("$_baseUrl/$_championDataPath/$championId.json");

    return Champion.fromJson(id: championId, json: json);
  }

  String getChampionTileUrl({required String championId, int skinCode = 0}) {
    return "$_baseUrl/img/champion/tiles/${championId}_$skinCode.jpg";
  }
}
