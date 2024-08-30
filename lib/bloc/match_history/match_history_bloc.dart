import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_event.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_state.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/matches/league_match.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/core/repository/match_repository.dart';

class MatchHistoryBloc extends Bloc<MatchHistoryEvent, MatchHistoryState> {
  final MatchRepository _matchRepository;

  MatchHistoryBloc(this._matchRepository) : super(MatchHistoryLoading()) {
    on<MatchHistoryStarted>(_onMatchHistoryStarted);
  }

  Future<void> _onMatchHistoryStarted(
      MatchHistoryStarted event, Emitter<MatchHistoryState> emit) async {
    emit(MatchHistoryLoading());
    try {
      Map<QueueType, List<LeagueMatch>> matches = {};
      for (var queueType in QueueType.values) {
        matches[queueType] =
            await _matchRepository.getMatchesByPuuidAndQueueType(
          event.region,
          event.puuid,
          queueType,
          count: event.count,
        );
      }
      emit(MatchHistoryLoaded(matches));
    } catch (e) {
      emit(MatchHistoryError(e));
    }
  }
}
