import 'package:equatable/equatable.dart';

class MatchHistoryEvent extends Equatable {
  const MatchHistoryEvent();

  @override
  List<Object?> get props => [];
}

class MatchHistoryStarted extends MatchHistoryEvent {
  final String region, puuid;
  final int count;

  const MatchHistoryStarted(this.region, this.puuid, {this.count = 5});

  @override
  List<Object?> get props => [region, puuid, count];
}
