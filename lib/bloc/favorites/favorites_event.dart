import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesStarted extends FavoritesEvent {
  @override
  List<Object?> get props => [];
}

class AddedChampionToFavorites extends FavoritesEvent {
  final Champion addedChampion;

  const AddedChampionToFavorites({required this.addedChampion});

  @override
  List<Object?> get props => [addedChampion];
}

class RemovedChampionFromFavorites extends FavoritesEvent {
  final Champion removedChampion;

  const RemovedChampionFromFavorites({required this.removedChampion});

  @override
  List<Object?> get props => [removedChampion];
}

final class ApplicationLanguageChanged extends FavoritesEvent {
  final AvailableLanguages newLanguage;

  const ApplicationLanguageChanged(this.newLanguage);

  @override
  List<Object?> get props => [newLanguage];
}
