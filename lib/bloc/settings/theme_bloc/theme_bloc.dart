import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_event.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';
import 'package:league_of_legends_library/core/repository/setting_repository.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SettingRepository settingRepository;

  ThemeBloc({required this.settingRepository}) : super(ThemeLoading()) {
    on<ThemeStarted>(_onStarted);
    on<ChangeThemeMode>(_onChanged);
  }

  Future<void> _onStarted(ThemeStarted event, Emitter<ThemeState> emit) async {
    emit(ThemeLoading());
    try {
      final AppThemeMode themeMode = settingRepository.getThemeMode();
      emit(ThemeLoaded(themeMode));
    } catch (_) {
      emit(ThemeError());
    }
  }

  Future<void> _onChanged(
      ChangeThemeMode event, Emitter<ThemeState> emit) async {
    final state = this.state;
    if (state is ThemeLoaded) {
      try {
        if (await settingRepository.setThemeMode(event.themeMode)) {
          emit(ThemeLoaded(event.themeMode));
        }
      } catch (_) {
        emit(ThemeError());
      }
    }
  }
}
