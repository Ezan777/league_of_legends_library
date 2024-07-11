import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_event.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

class RecentlyViewedBloc
    extends Bloc<RecentlyViewedEvent, RecentlyViewedState> {
  final ChampionRepository championRepository;
  AvailableLanguages language;

  RecentlyViewedBloc(
      {required this.championRepository,
      this.language = AvailableLanguages.americanEnglish})
      : super(RecentlyViewedLoading()) {
    on<RecentlyViewedStarted>(_onStarted);
    on<AddChampionToRecentlyViewed>(_onChampionAdded);
    on<ChangedLanguage>(_onLanguageChanged);
  }

  Future<void> _onStarted(
      RecentlyViewedStarted event, Emitter<RecentlyViewedState> emit) async {
    emit(RecentlyViewedLoading());
    try {
      final recentlyViewedChampions = await Future.wait(championRepository
          .recentlyViewedChampions
          .map((championId) => championRepository.getChampionById(
              championId: championId, languageCode: language.localeCode))
          .toList());
      emit(RecentlyViewedLoaded(Queue.from(recentlyViewedChampions)));
    } on InternetConnectionUnavailable catch (_) {
      emit(RecentlyViewedNoConnection());
    } catch (_) {
      emit(RecentlyViewedError());
    }
  }

  Future<void> _onChampionAdded(AddChampionToRecentlyViewed event,
      Emitter<RecentlyViewedState> emit) async {
    final state = this.state;
    if (state is RecentlyViewedLoaded) {
      try {
        final Queue<Champion> recentlyViewedChampions =
            Queue.from(state.recentlyViewedChampions);
        if (await championRepository.addRecentlyViewedChampion(
            championId: event.addedChampion.id)) {
          if (!recentlyViewedChampions.contains(event.addedChampion)) {
            // If the queue is full remove the last item (first that was inserted)
            while (recentlyViewedChampions.length >=
                championRepository.maxRecentlyViewedChampions) {
              recentlyViewedChampions.removeLast();
            }

            // Add the new value to the list
            recentlyViewedChampions.addFirst(event.addedChampion);
          } else {
            // Champion is inside the queue moving it to the top of the queue
            recentlyViewedChampions.remove(event.addedChampion);
            recentlyViewedChampions.addFirst(event.addedChampion);
          }
          emit(RecentlyViewedLoaded(recentlyViewedChampions));
        }
      } catch (_) {
        emit(RecentlyViewedError());
      }
    }
  }

  Future<void> _onLanguageChanged(
      ChangedLanguage event, Emitter<RecentlyViewedState> emit) async {
    language = event.newLanguage;
    final recentlyViewedChampions = await Future.wait(championRepository
        .recentlyViewedChampions
        .map((championId) => championRepository.getChampionById(
            championId: championId, languageCode: language.localeCode))
        .toList());
    emit(RecentlyViewedLoaded(Queue.from(recentlyViewedChampions),
        language: language));
  }
}
