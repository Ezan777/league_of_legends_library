import 'package:league_of_legends_library/core/model/league_of_legends/matches/summoner_spells.dart';

class Participant {
  final int championLevel;
  final String championId;
  final int kills, deaths, assists;
  final double kda;
  final List<SummonerSpells> summonerSpells;
  final int goldEarned;
  final List<int> itemsId;
  final int trinketId;
  final int totalDamageDealt;
  final int visionScore;
  final int minionsKilled;
  final String summonerId, puuid, name, tag;
  final bool isWinner;
  final List<String> itemsIconUri, summonerSpellsIconUri;
  final String championIconUri, trinketIconUri;

  const Participant({
    required this.championId,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.summonerSpells,
    required this.goldEarned,
    required this.itemsId,
    required this.totalDamageDealt,
    required this.visionScore,
    required this.championLevel,
    required this.minionsKilled,
    required this.summonerId,
    required this.puuid,
    required this.name,
    required this.tag,
    required this.isWinner,
    required this.championIconUri,
    required this.itemsIconUri,
    required this.summonerSpellsIconUri,
    required this.trinketId,
    required this.trinketIconUri,
  }) : kda = ((kills + deaths + assists) / 3);
}
