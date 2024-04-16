import 'package:league_of_legends_library/data/local_data_source.dart';
import 'package:league_of_legends_library/data/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImplLocalDataSource implements LocalDataSource {
  final SharedPreferences _sharedPreferences;

  ImplLocalDataSource({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  List<String>? getFavoritesChampions() {
    return _sharedPreferences
        .getStringList(SharedPreferencesKeys.favorites.key);
  }

  @override
  Future<bool> saveFavoritesChampions(
      {required List<String> favoritesChampions}) async {
    return await _sharedPreferences.setStringList(
        SharedPreferencesKeys.favorites.key, favoritesChampions);
  }
}