import 'dart:collection';

abstract class LocalDataSource {
  List<String>? getFavoritesChampions();
  Queue<String>? getRecentlyViewedChampions();
  String? getSerializedChampionsSkins();
  Future<bool> saveFavoritesChampions(
      {required List<String> favoritesChampions});
  Future<bool> saveRecentlyViewedChampions(
      {required List<String> recentlyViewedChampions});
  Future<bool> saveSerializedChampionsSkins(
      {required String serializedChampionsSkin});
}
