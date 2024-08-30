import 'dart:convert';

import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/data/dto/match_dto.dart';
import 'package:league_of_legends_library/data/dto/participant_dto.dart';
import 'package:league_of_legends_library/data/match_data_source.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';
import 'package:http/http.dart' as http;

class RiotMatchApi with RemoteDataSource implements MatchDataSource {
  final String _apiKey;

  const RiotMatchApi(this._apiKey);

  @override
  Future<MatchDto> getMatchByMatchId(
      String region, String matchId, QueueType queueType) async {
    await checkConnection();
    final Uri endpoint = Uri.parse(
        "https://$region.api.riotgames.com/lol/match/v5/matches/$matchId?api_key=$_apiKey");

    final response = await http.get(endpoint);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final participantsJsonData = json["info"]["participants"] as List;
      final List<ParticipantDto> participants = participantsJsonData
          .map((participantData) => _getParticipantFromJson(participantData))
          .toList();

      return MatchDto(
          gameId: matchId,
          queueType: queueType,
          participants: participants,
          gameCreationTimeStamp: json["info"]["gameCreation"],
          gameDurationInSeconds: json["info"]["gameDuration"]);
    } else if (response.statusCode == 429) {
      throw RateLimitExceeded();
    } else {
      throw Exception(
          "An error has occurred while retrieving summoner puuid - Error code: ${response.statusCode}");
    }
  }

  @override
  Future<List<String>> getMatchIdListByPuuid(
      String region, String puuid, int count, QueueType queueType) async {
    await checkConnection();

    final Uri endpoint = Uri.parse(
        "https://$region.api.riotgames.com/lol/match/v5/matches/by-puuid/$puuid/ids?queue=${_getRequestQueueType(queueType)}&type=ranked&start=0&count=$count&api_key=$_apiKey");

    final response = await http.get(endpoint);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final List<String> matchesId = List.empty(growable: true);
      for (String matchId in json) {
        matchesId.add(matchId);
      }
      return matchesId;
    } else if (response.statusCode == 429) {
      throw RateLimitExceeded();
    } else {
      throw Exception(
          "An error has occurred while retrieving summoner puuid - Error code: ${response.statusCode}");
    }
  }

  ParticipantDto _getParticipantFromJson(
          Map<String, dynamic> participantData) =>
      ParticipantDto(
        championId: participantData["championName"],
        kills: participantData["kills"],
        deaths: participantData["deaths"],
        assists: participantData["assists"],
        firstSummonerSpellKey: participantData["summoner1Id"],
        secondSummonerSpellKey: participantData["summoner2Id"],
        goldEarned: participantData["goldEarned"],
        itemsId: List<int>.from([
          participantData["item0"],
          participantData["item1"],
          participantData["item2"],
          participantData["item3"],
          participantData["item4"],
          participantData["item5"],
        ]),
        trinketId: participantData["item6"],
        totalDamageDealt: participantData["magicDamageDealtToChampions"] +
            participantData["physicalDamageDealtToChampions"] +
            participantData["trueDamageDealtToChampions"],
        visionScore: participantData["visionScore"],
        championLevel: participantData["champLevel"],
        minionsKilled: participantData["totalMinionsKilled"],
        summonerId: participantData["summonerId"],
        puuid: participantData["puuid"],
        name: participantData["riotIdGameName"],
        tag: participantData["riotIdTagline"],
        isWinner: participantData["win"],
      );

  String _getRequestQueueType(QueueType queueType) => switch (queueType) {
        QueueType.soloDuo => "420",
        QueueType.flex => "440",
      };
}
