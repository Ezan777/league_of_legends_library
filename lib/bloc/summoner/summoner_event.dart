import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/data/riot_api.dart';

abstract class SummonerEvent extends Equatable {
  const SummonerEvent();

  @override
  List<Object?> get props => [];
}

class SummonerStarted extends SummonerEvent {
  final String name;
  final String tagLine;
  final RiotServer server;

  const SummonerStarted(this.name, this.tagLine, this.server);

  @override
  List<Object?> get props => [name, tagLine, server];
}
