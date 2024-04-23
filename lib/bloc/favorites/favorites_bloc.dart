import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_event.dart';
import 'package:league_of_legends_library/bloc/favorites/favorites_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final ChampionRepository championRepository;
  AvailableLanguages language;

  FavoritesBloc(
      {required this.championRepository,
      this.language = AvailableLanguages.americanEnglish})
      : super(FavoritesLoading()) {
    on<FavoritesStarted>(_onStarted);
    on<AddedChampionToFavorites>(_onChampionAdded);
    on<RemovedChampionFromFavorites>(_onChampionRemoved);
  }

  Future<void> _onStarted(
      FavoritesStarted event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favoriteChampions = await Future.wait(championRepository
          .favoritesChampions
          .map((championId) => championRepository.getChampionById(
              championId: championId, languageCode: language.languageCode))
          .toList());
      emit(FavoritesLoaded(favoriteChampions));
    } catch (_) {
      emit(FavoritesError());
    }
  }

  Future<void> _onChampionAdded(
      AddedChampionToFavorites event, Emitter<FavoritesState> emit) async {
    final state = this.state;
    if (state is FavoritesLoaded) {
      try {
        if (await championRepository.addFavoriteChampion(
            championId: event.addedChampion.id)) {
          emit(FavoritesLoaded(
              (state).favoriteChampions + [event.addedChampion]));
        } else {
          emit(FavoritesError());
        }
      } catch (_) {
        emit(FavoritesError());
      }
    }
  }

  Future<void> _onChampionRemoved(
      RemovedChampionFromFavorites event, Emitter<FavoritesState> emit) async {
    final state = this.state;
    if (state is FavoritesLoaded) {
      try {
        if (await championRepository.removeFavoriteChampion(
            championId: event.removedChampion.id)) {
          final List<Champion> favoriteChampions =
              List.from(state.favoriteChampions);
          favoriteChampions.remove(event.removedChampion);
          emit(FavoritesLoaded(favoriteChampions));
        }
      } catch (_) {
        emit(FavoritesError());
      }
    }
  }

  Future<void> _onLanguageChanged(
      ApplicationLanguageChanged event, Emitter<FavoritesState> emit) async {
    language = event.newLanguage;
    final favoriteChampions = await Future.wait(championRepository
        .favoritesChampions
        .map((championId) => championRepository.getChampionById(
            championId: championId, languageCode: language.languageCode))
        .toList());
    emit(FavoritesLoaded(favoriteChampions, language: language));
  }
}
