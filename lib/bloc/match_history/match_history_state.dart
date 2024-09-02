import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/matches/league_match.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';

sealed class MatchHistoryState extends Equatable {
  const MatchHistoryState();

  @override
  List<Object?> get props => [];
}

final class MatchHistoryLoaded extends MatchHistoryState {
  final Map<QueueType, List<LeagueMatch>> matches;
  final bool isLoadingOtherMatches;

  const MatchHistoryLoaded(this.matches, this.isLoadingOtherMatches);

  @override
  List<Object?> get props => [matches, isLoadingOtherMatches];
}

final class MatchHistoryLoading extends MatchHistoryState {}

final class MatchHistoryError extends MatchHistoryState {
  final Object? error;

  const MatchHistoryError(this.error);
}
