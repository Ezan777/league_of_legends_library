import 'package:league_of_legends_library/core/model/league_of_legends/matches/participant.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';

class LeagueMatch {
  final String gameId;
  final QueueType queueType;
  final List<Participant> participants;
  final DateTime gameCreation;
  final Duration gameDuration;

  const LeagueMatch(
      {required this.gameId,
      required this.queueType,
      required this.participants,
      required this.gameCreation,
      required this.gameDuration});

  List<Participant> get blueTeam => participants.sublist(0, 5);
  List<Participant> get redTeam => participants.sublist(5, 10);
  String get gameCreationDateString =>
      "${gameCreation.day}/${gameCreation.month}/${gameCreation.year}";
  String get gameDurationString =>
      "${gameDuration.inMinutes}:${(gameDuration.inSeconds - gameDuration.inMinutes * 60).toString().padLeft(2, "0")}";
}
