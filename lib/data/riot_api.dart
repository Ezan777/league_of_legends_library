import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:league_of_legends_library/core/model/rank.dart';
import 'package:http/http.dart' as http;
import 'package:league_of_legends_library/data/assets_data_source.dart';
import 'package:league_of_legends_library/data/dto/summoner_dto.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';
import 'package:league_of_legends_library/data/summoner_data_source.dart';

class RiotApi implements SummonerDataSource, RemoteDataSource {
  final String _apiKey;

  const RiotApi(this._apiKey);

  @override
  Future<String> getPuuidByNameAndTagLine(
      String name, String tagLine, String regionCode) async {
    await checkConnection();

    final response = await http.get(Uri.parse(
        "https://$regionCode.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$name/$tagLine?api_key=$_apiKey"));

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return json["puuid"];
    } else if (response.statusCode == 404) {
      throw SummonerNotFound();
    } else {
      throw Exception(
          "An error has occurred while retrieving summoner puuid - Error code: ${response.statusCode}");
    }
  }

  @override
  Future<SummonerDto> getSummonerDataByPuuid(
      String puuid, String serverCode) async {
    await checkConnection();

    final response = await http.get(Uri.parse(
        "https://$serverCode.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/$puuid?api_key=$_apiKey"));

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return SummonerDto.fromJson(json);
    } else if (response.statusCode == 404) {
      throw SummonerNotFound();
    } else {
      throw Exception(
          "An error has occurred while retrieving summoner data - Error code: ${response.statusCode}");
    }
  }

  @override
  Future<List<Rank>> getSummonerRanksBySummonerId(
      String summonerId, String serverCode) async {
    await checkConnection();

    final response = await http.get(Uri.parse(
        "https://$serverCode.api.riotgames.com/lol/league/v4/entries/by-summoner/$summonerId?api_key=$_apiKey"));

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      List<Rank> ranks = List.empty(growable: true);
      for (Map<String, dynamic> rankData in json) {
        if (rankData["queueType"] == RiotQueueType.soloDuo.queueCode ||
            rankData["queueType"] == RiotQueueType.flex.queueCode) {
          ranks.add(
            Rank(
              tier: rankData["tier"],
              rank: rankData["rank"],
              leaguePoints: rankData["leaguePoints"],
              queueType:
                  RiotQueueType.fromString(rankData["queueType"]).toQueueType(),
              wins: rankData["wins"],
              losses: rankData["losses"],
            ),
          );
        }
      }

      return ranks;
    } else {
      throw Exception(
          "An error has occurred while retrieving rank data - Error code: ${response.statusCode}");
    }
  }

  @override
  Future<void> checkConnection() async {
    final connection = await Connectivity().checkConnectivity();
    if (connection.firstOrNull == ConnectivityResult.none) {
      throw InternetConnectionUnavailable();
    }
  }
}

enum RiotServer {
  europeWest("EUW1"),
  europeNorthWest("EUN1"),
  brasil("BR1"),
  japan("JP1"),
  korea("KR"),
  latinAmericaNorth("LA1"),
  latinAmericaSouth("LA2"),
  northAmerica("NA1"),
  oceania("OC1"),
  russia("RU1"),
  turkey("TR1"),
  middleEast("ME1"),
  philippines("PH2"),
  singapore("SG2"),
  taiwan("TW2"),
  thailand("TH2"),
  vietnam("VN2");

  final String serverCode;

  const RiotServer(this.serverCode);

  factory RiotServer.fromServerCode(String serverCode) => switch (serverCode) {
        "EUW1" => RiotServer.europeWest,
        "EUN1" => RiotServer.europeNorthWest,
        "BR1" => RiotServer.brasil,
        "JP1" => RiotServer.japan,
        "KR" => RiotServer.korea,
        "LA1" => RiotServer.latinAmericaNorth,
        "LA2" => RiotServer.latinAmericaSouth,
        "NA1" => RiotServer.northAmerica,
        "OC1" => RiotServer.oceania,
        "RU1" => RiotServer.russia,
        "TR1" => RiotServer.turkey,
        "ME1" => RiotServer.middleEast,
        "PH2" => RiotServer.philippines,
        "SG2" => RiotServer.singapore,
        "TW2" => RiotServer.taiwan,
        "TH2" => RiotServer.thailand,
        "VN2" => RiotServer.vietnam,
        _ => throw Exception("$serverCode is not a valid server code"),
      };

  String displayableServerCode() => serverCode.replaceAll(RegExp(r"\d+"), "");
}

enum RiotRegion {
  americas("americas"),
  asia("asia"),
  europe("europe"),
  sea("sea");

  final String regionCode;

  const RiotRegion(this.regionCode);

  factory RiotRegion.fromServer(RiotServer server) => switch (server) {
        RiotServer.europeWest ||
        RiotServer.europeNorthWest ||
        RiotServer.turkey ||
        RiotServer.russia =>
          RiotRegion.europe,
        RiotServer.northAmerica ||
        RiotServer.latinAmericaNorth ||
        RiotServer.latinAmericaSouth ||
        RiotServer.brasil =>
          RiotRegion.americas,
        RiotServer.japan ||
        RiotServer.korea ||
        RiotServer.middleEast =>
          RiotRegion.asia,
        RiotServer.oceania ||
        RiotServer.singapore ||
        RiotServer.taiwan ||
        RiotServer.thailand ||
        RiotServer.vietnam ||
        RiotServer.philippines =>
          RiotRegion.sea,
      };
}

enum RiotQueueType {
  soloDuo("RANKED_SOLO_5x5"),
  flex("RANKED_TEAM_5x5");

  final String queueCode;

  const RiotQueueType(this.queueCode);

  factory RiotQueueType.fromString(String queueCode) => switch (queueCode) {
        "RANKED_SOLO_5x5" => RiotQueueType.soloDuo,
        "RANKED_TEAM_5x5" => RiotQueueType.flex,
        _ => throw Exception("$queueCode is not a valid queue code"),
      };

  QueueType toQueueType() => switch (this) {
        RiotQueueType.soloDuo => QueueType.soloDuo,
        RiotQueueType.flex => QueueType.flex,
      };
}
