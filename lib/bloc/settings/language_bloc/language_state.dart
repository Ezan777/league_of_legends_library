import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

sealed class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

final class LanguageLoading extends LanguageState {}

final class LanguageLoaded extends LanguageState {
  final AvailableLanguages language;

  const LanguageLoaded(this.language);

  @override
  List<Object?> get props => [language];
}

final class LanguageError extends LanguageState {}
