import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<Champion> favoriteChampions;
  final AvailableLanguages? language;

  FavoritesLoaded(this.favoriteChampions, {this.language}) {
    favoriteChampions.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  List<Object?> get props => [favoriteChampions, language];
}

final class FavoritesError extends FavoritesState {}

final class FavoritesNoConnection extends FavoritesState {}
