import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/summoner.dart';
import 'package:league_of_legends_library/data/assets_data_source.dart';
import 'package:league_of_legends_library/data/riot_summoner_api.dart';
import 'package:league_of_legends_library/data/summoner_data_source.dart';

class SummonerRepository {
  final SummonerDataSource _summonerDataSource;
  final AssetsDataSource _assetsDataSource;

  const SummonerRepository(this._summonerDataSource, this._assetsDataSource);

  Future<Summoner> getSummonerByNameAndTagLine(
      String name, String tagLine, RiotServer server) async {
    final puuid = await _summonerDataSource.getPuuidByNameAndTagLine(
        name, tagLine, RiotRegion.fromServer(server).regionCode);
    final summonerDto = await _summonerDataSource.getSummonerDataByPuuid(
        puuid, server.serverCode);
    final ranksDto = await _summonerDataSource.getSummonerRanksBySummonerId(
        summonerDto.id, server.serverCode);
    final ranks = ranksDto
        .map(
          (rankDto) => Rank(
              tier: rankDto.tier,
              rank: rankDto.rank,
              leaguePoints: rankDto.leaguePoints,
              queueType: rankDto.queueType,
              wins: rankDto.wins,
              losses: rankDto.losses,
              tierIconUri: _assetsDataSource.getTierIconUri(rankDto.tier)),
        )
        .toList();
    ranks.sort(
      (a, b) => a.compareTo(b),
    );

    return Summoner(
        summonerId: summonerDto.id,
        puuid: puuid,
        name: name,
        tag: tagLine,
        serverCode: server.serverCode,
        ranks: ranks,
        profileIconId: summonerDto.profileIconId,
        level: summonerDto.summonerLevel,
        profileIconUri: _assetsDataSource
            .getProfileIconUri(summonerDto.profileIconId.toString()));
  }
}
