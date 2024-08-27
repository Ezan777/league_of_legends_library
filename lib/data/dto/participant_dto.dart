import 'package:league_of_legends_library/core/model/league_of_legends/matches/participant.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/matches/summoner_spells.dart';

class ParticipantDto {
  final int championLevel;
  final String championId;
  final int kills, deaths, assists;
  final double kda;
  final int firstSummonerSpellKey, secondSummonerSpellKey;
  final int goldEarned;
  final List<int> itemsId;
  final int trinketId;
  final int totalDamageDealt;
  final int visionScore;
  final int minionsKilled;
  final String summonerId, puuid, name, tag;
  final bool isWinner;

  ParticipantDto({
    required this.championId,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.firstSummonerSpellKey,
    required this.secondSummonerSpellKey,
    required this.goldEarned,
    required this.itemsId,
    required this.trinketId,
    required this.totalDamageDealt,
    required this.visionScore,
    required this.championLevel,
    required this.minionsKilled,
    required this.summonerId,
    required this.puuid,
    required this.name,
    required this.tag,
    required this.isWinner,
  }) : kda = ((kills + deaths + assists) / 3) {
    itemsId.removeWhere((itemId) => itemId == 0);
  }

  Participant toParticipant(String championIconUri, List<String> itemsIconUri,
          List<String> summonerSpellsIconUri, String trinketIconUri) =>
      Participant(
          championId: championId,
          kills: kills,
          deaths: deaths,
          assists: assists,
          summonerSpells: [
            SummonerSpells.fromKey(firstSummonerSpellKey),
            SummonerSpells.fromKey(secondSummonerSpellKey),
          ],
          goldEarned: goldEarned,
          itemsId: itemsId,
          totalDamageDealt: totalDamageDealt,
          visionScore: visionScore,
          championLevel: championLevel,
          minionsKilled: minionsKilled,
          summonerId: summonerId,
          puuid: puuid,
          name: name,
          tag: tag,
          isWinner: isWinner,
          championIconUri: championIconUri,
          itemsIconUri: itemsIconUri,
          summonerSpellsIconUri: summonerSpellsIconUri,
          trinketId: trinketId,
          trinketIconUri: trinketIconUri);
}
