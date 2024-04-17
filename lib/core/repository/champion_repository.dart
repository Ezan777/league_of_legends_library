import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/data/local_data_source.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';

class ChampionRepository {
  // TODO: I should clean some code, move varibales to remote data source
  List<String>? _favoritesChampions;
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  static const String baseUrl =
      "https://league-of-legends-library.web.app"; //https://dragontail.enricozangrando.com";
  final String _championDataPath = "14.7.1/data/en_US/champion";

  ChampionRepository(
      {required RemoteDataSource remoteDataSource,
      required LocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource {
    _favoritesChampions = _localDataSource.getFavoritesChampions();
  }

  List<String> get favoritesChampions => _favoritesChampions ?? List.empty();

  /// Return the champion with the given [championId].
  Future<Champion> getChampionById({required String championId}) async {
    final json = await _remoteDataSource
        .fetchJson("$baseUrl/$_championDataPath/$championId.json");

    return Champion.fromJson(
        id: championId,
        json: json,
        isFavorite: _favoritesChampions?.contains(championId) ?? false);
  }

  /// Return a list containing all champions ids. If the data obtained from json is invalid it will return an empty list.
  Future<List<String>> getAllChampionIds() async {
    final json = await _remoteDataSource
        .fetchJson("$baseUrl/14.7.1/data/en_US/champion.json");
    List<String> ids;
    final jsonData = json["data"];

    if (jsonData is Map) {
      final Map<String, dynamic> dataMap = jsonData.cast<String, dynamic>();
      ids = List.from(dataMap.keys);
    } else {
      ids = List.empty();
    }

    return ids;
  }

  String getChampionTileUrl({required String championId, int skinCode = 0}) {
    // This is needed because Fiddlesticks images are broken and named FiddleSticks...
    if (championId == "Fiddlesticks") {
      championId = "FiddleSticks";
    }

    return "$baseUrl/img/champion/tiles/${championId}_$skinCode.jpg";
  }

  static String getSpellTileUrl({required String spellId}) {
    return "$baseUrl/14.7.1/img/spell/$spellId.png";
  }

  Future<bool> setFavoriteChampion({required String championId}) async {
    _favoritesChampions?.add(championId);
    return await _localDataSource.saveFavoritesChampions(
        favoritesChampions: _favoritesChampions ?? List.empty());
  }

  Future<bool> removeFavoriteChampion({required String championId}) async {
    _favoritesChampions?.remove(championId);
    return await _localDataSource.saveFavoritesChampions(
        favoritesChampions: _favoritesChampions ?? List.empty());
  }
}
