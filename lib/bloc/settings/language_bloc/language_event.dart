import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

final class LanguageStarted extends LanguageEvent {
  final AvailableLanguages? platformLanguage;

  const LanguageStarted(this.platformLanguage);

  @override
  List<Object?> get props => [platformLanguage];
}

final class ChangeLanguage extends LanguageEvent {
  final AvailableLanguages newLanguage;

  const ChangeLanguage(this.newLanguage);

  @override
  List<Object?> get props => [newLanguage];
}
