import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';
import 'package:league_of_legends_library/data/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingDataSource {
  final SharedPreferences _sharedPreferences;

  const SettingDataSource(this._sharedPreferences);

  String? getThemeMode() {
    return _sharedPreferences.getString(SharedPreferencesKeys.themeMode.key);
  }

  Future<bool> setThemeMode(AppThemeMode themeMode) async {
    return await _sharedPreferences.setString(
        SharedPreferencesKeys.themeMode.key, themeMode.toString());
  }
}
