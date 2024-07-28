import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/summoner.dart';

sealed class SummonerState extends Equatable {
  const SummonerState();

  @override
  List<Object?> get props => [];
}

final class SummonerLoading extends SummonerState {}

final class SummonerSuccess extends SummonerState {
  final Summoner summoner;

  const SummonerSuccess(this.summoner);

  @override
  List<Object?> get props => [summoner.summonerId];
}

final class SummonerError extends SummonerState {
  final Object? error;

  const SummonerError(this.error);

  @override
  List<Object?> get props => [error];
}
