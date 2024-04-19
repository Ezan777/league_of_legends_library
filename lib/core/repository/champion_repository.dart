import 'dart:collection';

import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/data/local_data_source.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';

class ChampionRepository {
  // TODO: I should clean some code, move varibales to remote data source
  List<String>? _favoritesChampions;
  Queue<String>? _recentlyViewedChampions;
  final int maxRecentlyViewedChampions = 6;
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
    _recentlyViewedChampions = _localDataSource.getRecentlyViewedChampions();
  }

  List<String> get favoritesChampions => _favoritesChampions ?? List.empty();
  List<String> get recentlyViewedChampions =>
      _recentlyViewedChampions?.toList() ?? List.empty();

  /// Return the champion with the given [championId].
  Future<Champion> getChampionById({required String championId}) async {
    final json = await _remoteDataSource
        .fetchJson("$baseUrl/$_championDataPath/$championId.json");

    return Champion.fromJson(
      id: championId,
      json: json,
    );
  }

  Future<List<Champion>> getChampionsById(
      {required List<String> championsIds}) async {
    return Future.wait(championsIds
        .map((id) async => Champion.fromJson(
              id: id,
              json: await _remoteDataSource
                  .fetchJson("$baseUrl/$_championDataPath/$id.json"),
            ))
        .toList());
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

  static String getFullChampionImageUrl(
      {required String championId, int skinCode = 0}) {
    // This is needed because Fiddlesticks images are broken and named FiddleSticks...
    if (championId == "Fiddlesticks") {
      championId = "FiddleSticks";
    }

    return "$baseUrl/img/champion/centered/${championId}_$skinCode.jpg";
  }

  static String getSpellTileUrl({required String spellId}) {
    return "$baseUrl/14.7.1/img/spell/$spellId.png";
  }

  Future<bool> addFavoriteChampion({required String championId}) async {
    _favoritesChampions?.add(championId);
    return await _localDataSource.saveFavoritesChampions(
        favoritesChampions: _favoritesChampions ?? List.empty());
  }

  Future<bool> removeFavoriteChampion({required String championId}) async {
    _favoritesChampions?.remove(championId);
    return await _localDataSource.saveFavoritesChampions(
        favoritesChampions: _favoritesChampions ?? List.empty());
  }

  Future<bool> addRecentlyViewedChampion({required String championId}) async {
    if (_recentlyViewedChampions != null) {
      // Value is not null, I check if it contains the championId I am going to add
      if (!_recentlyViewedChampions!.contains(championId)) {
        // If the queue is full remove the last item (first that was inserted)
        while (_recentlyViewedChampions!.length >= maxRecentlyViewedChampions) {
          _recentlyViewedChampions!.removeLast();
        }

        // Add the new value to the list
        _recentlyViewedChampions!.addFirst(championId);
      } else {
        // Champion is inside the queue moving it to the top of the queue
        _recentlyViewedChampions!.remove(championId);
        _recentlyViewedChampions!.addFirst(championId);
      }
    }
    return await _localDataSource.saveRecentlyViewedChampions(
        recentlyViewedChampions:
            _recentlyViewedChampions?.toList() ?? List.empty());
  }

  bool isChampionFavorite({required String championId}) =>
      _favoritesChampions?.contains(championId) ?? false;
}
