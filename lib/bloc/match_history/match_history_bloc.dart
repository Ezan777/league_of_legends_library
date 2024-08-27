import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_event.dart';
import 'package:league_of_legends_library/bloc/match_history/match_history_state.dart';
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
      final matches = await _matchRepository.getMatchesByPuuidAndQueueType(
        event.region,
        event.puuid,
        event.queueType,
        count: event.count,
      );
      emit(MatchHistoryLoaded(matches, event.queueType));
    } catch (e) {
      emit(MatchHistoryError(e));
    }
  }
}
