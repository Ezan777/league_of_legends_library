import 'dart:collection';

abstract class LocalDataSource {
  List<String>? getFavoritesChampions();
  Queue<String>? getRecentlyViewedChampions();
  Future<bool> saveFavoritesChampions(
      {required List<String> favoritesChampions});
  Future<bool> saveRecentlyViewedChampions(
      {required List<String> recentlyViewedChampions});
}
