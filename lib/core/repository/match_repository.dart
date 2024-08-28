import 'package:league_of_legends_library/core/model/league_of_legends/matches/league_match.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/matches/summoner_spells.dart';
import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/data/assets_data_source.dart';
import 'package:league_of_legends_library/data/dto/match_dto.dart';
import 'package:league_of_legends_library/data/match_data_source.dart';

class MatchRepository {
  final MatchDataSource _matchDataSource;
  final AssetsDataSource _assetsDataSource;

  const MatchRepository(this._matchDataSource, this._assetsDataSource);

  Future<List<LeagueMatch>> getMatchesByPuuidAndQueueType(
      String region, String puuid, QueueType queueType,
      {int count = 5}) async {
    final matchesIdList = await _matchDataSource.getMatchIdListByPuuid(
        region, puuid, count, queueType);
    final matchesDto = List<MatchDto>.empty(growable: true);

    for (String matchId in matchesIdList) {
      final matchDto =
          await _matchDataSource.getMatchByMatchId(region, matchId, queueType);
      matchesDto.add(matchDto);
    }

    return matchesDto
        .map((matchDto) => LeagueMatch(
            gameId: matchDto.gameId,
            queueType: matchDto.queueType,
            gameCreation: DateTime.fromMillisecondsSinceEpoch(
                matchDto.gameCreationTimeStamp),
            gameDuration: Duration(seconds: matchDto.gameDurationInSeconds),
            participants: matchDto.participants
                .map((participantDto) => participantDto.toParticipant(
                      _assetsDataSource
                          .getChampionTileUri(participantDto.championId),
                      participantDto.itemsId
                          .map((itemId) => _assetsDataSource
                              .getIemTileUri(itemId.toString()))
                          .toList(),
                      [
                        _assetsDataSource.getSummonerSpellTileBySpellId(
                            SummonerSpells.fromKey(
                                    participantDto.firstSummonerSpellKey)
                                .spellId),
                        _assetsDataSource.getSummonerSpellTileBySpellId(
                            SummonerSpells.fromKey(
                                    participantDto.secondSummonerSpellKey)
                                .spellId),
                      ],
                      _assetsDataSource.getIemTileUri(
                        participantDto.trinketId.toString(),
                      ),
                    ))
                .toList()))
        .toList();
  }
}
