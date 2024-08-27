import 'package:league_of_legends_library/core/model/league_of_legends/matches/participant.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';

class LeagueMatch {
  final String gameId;
  final QueueType queueType;
  final List<Participant> participants;

  const LeagueMatch(
      {required this.gameId,
      required this.queueType,
      required this.participants});

  List<Participant> get blueTeam => participants.sublist(0, 5);
  List<Participant> get redTeam => participants.sublist(5, 10);
}
