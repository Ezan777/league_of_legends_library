import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';

class MatchHistoryEvent extends Equatable {
  const MatchHistoryEvent();

  @override
  List<Object?> get props => [];
}

class MatchHistoryStarted extends MatchHistoryEvent {
  final String region, puuid;
  final QueueType queueType;
  final int count;

  const MatchHistoryStarted(this.region, this.puuid, this.queueType,
      {this.count = 5});

  @override
  List<Object?> get props => [region, puuid, queueType, count];
}
