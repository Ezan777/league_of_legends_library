import 'package:league_of_legends_library/core/model/rank.dart';
import 'package:league_of_legends_library/data/dto/summoner_dto.dart';

abstract class SummonerDataSource {
  Future<String> getPuuidByNameAndTagLine(
      String name, String tagLine, String regionCode);
  Future<SummonerDto> getSummonerDataByPuuid(String puuid, String serverCode);
  Future<List<Rank>> getSummonerRanksBySummonerId(
      String summonerId, String serverCode);
}

class SummonerNotFound implements Exception {}
