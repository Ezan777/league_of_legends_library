abstract class LocalDataSource {
  List<String>? getFavoritesChampions();
  Future<bool> saveFavoritesChampions(
      {required List<String> favoritesChampions});
}
