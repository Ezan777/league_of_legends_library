import 'package:league_of_legends_library/core/model/summoner.dart';
import 'package:league_of_legends_library/data/assets_data_source.dart';
import 'package:league_of_legends_library/data/riot_api.dart';
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
    final ranks = await _summonerDataSource.getSummonerRanksBySummonerId(
        summonerDto.id, server.serverCode);

    return Summoner(
        summonerId: summonerDto.id,
        puuid: puuid,
        name: name,
        tag: tagLine,
        serverCode: server.serverCode,
        ranks: ranks,
        profileIconId: summonerDto.profileIconId,
        level: summonerDto.summonerLevel);
  }

  String getProfileIconUri(String profileIconId) =>
      _assetsDataSource.getProfileIconUri(profileIconId);
}
