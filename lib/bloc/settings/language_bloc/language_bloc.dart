import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_event.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_state.dart';
import 'package:league_of_legends_library/core/repository/setting_repository.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SettingRepository settingRepository;

  LanguageBloc({required this.settingRepository}) : super(LanguageLoading()) {
    on<LanguageStarted>(_onStarted);
    on<ChangeLanguage>(_onChange);
  }

  Future<void> _onStarted(
      LanguageStarted event, Emitter<LanguageState> emit) async {
    emit(LanguageLoading());
    try {
      final AvailableLanguages? savedLanguage = settingRepository.getLanguage();
      emit(LanguageLoaded(savedLanguage ??
          event.platformLanguage ??
          AvailableLanguages.americanEnglish));
    } catch (_) {
      emit(LanguageError());
    }
  }

  Future<void> _onChange(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    final state = this.state;
    if (state is LanguageLoaded) {
      try {
        if (await settingRepository.setLanguage(event.newLanguage)) {
          emit(LanguageLoaded(event.newLanguage));
        } else {
          emit(LanguageError());
        }
      } catch (_) {
        emit(LanguageError());
      }
    }
  }
}
