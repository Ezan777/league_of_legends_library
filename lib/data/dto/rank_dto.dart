import 'package:league_of_legends_library/core/model/rank.dart';
import 'package:league_of_legends_library/data/riot_api.dart';

class RankDto {
  final String tier;
  final String rank;
  final int leaguePoints;
  final QueueType queueType;
  final int wins;
  final int losses;

  const RankDto({
    required this.tier,
    required this.rank,
    required this.leaguePoints,
    required this.queueType,
    required this.wins,
    required this.losses,
  });

  factory RankDto.fromJson(Map<String, dynamic> json) {
    String tier = json["tier"].toString()[0].toUpperCase() +
        json["tier"].toString().substring(1).toLowerCase();

    return RankDto(
      tier: tier,
      rank: json["rank"],
      leaguePoints: json["leaguePoints"],
      queueType: RiotQueueType.fromString(json["queueType"]).toQueueType(),
      wins: json["wins"],
      losses: json["losses"],
    );
  }
}
