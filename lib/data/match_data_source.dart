import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/data/dto/match_dto.dart';

abstract class MatchDataSource {
  Future<MatchDto> getMatchByMatchId(
      String region, String matchId, QueueType queueType);
  Future<List<String>> getMatchIdListByPuuid(
      String region, String puuid, int count, QueueType queueType);
}
