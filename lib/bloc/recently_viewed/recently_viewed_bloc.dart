import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_event.dart';
import 'package:league_of_legends_library/bloc/recently_viewed/recently_viewed_state.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';

class RecentlyViewedBloc
    extends Bloc<RecentlyViewedEvent, RecentlyViewedState> {
  final ChampionRepository championRepository;

  RecentlyViewedBloc({required this.championRepository})
      : super(RecentlyViewedLoading()) {
    on<RecentlyViewedStarted>(_onStarted);
    on<AddChampionToRecentlyViewed>(_onChampionAdded);
  }

  Future<void> _onStarted(
      RecentlyViewedStarted event, Emitter<RecentlyViewedState> emit) async {
    emit(RecentlyViewedLoading());
    try {
      final recentlyViewedChampions = await championRepository.getChampionsById(
          championsIds: championRepository.recentlyViewedChampions);
      emit(RecentlyViewedLoaded(Queue.from(recentlyViewedChampions)));
    } catch (_) {
      RecentlyViewedError();
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
}
