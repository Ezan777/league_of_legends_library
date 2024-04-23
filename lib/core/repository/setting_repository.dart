import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';
import 'package:league_of_legends_library/data/setting_data_source.dart';

class SettingRepository {
  final SettingDataSource _settingDataSource;

  const SettingRepository(this._settingDataSource);

  AppThemeMode getThemeMode() {
    return AppThemeMode.fromString(
        _settingDataSource.getThemeMode() ?? AppThemeMode.followSystem.name);
  }

  Future<bool> setThemeMode(AppThemeMode themeMode) async {
    return await _settingDataSource.setThemeMode(themeMode);
  }
}
