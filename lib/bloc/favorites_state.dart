import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/champion.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<Champion> favoriteChampions;

  FavoritesLoaded(this.favoriteChampions) {
    favoriteChampions.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  List<Object> get props => [favoriteChampions];
}

final class FavoritesError extends FavoritesState {}
