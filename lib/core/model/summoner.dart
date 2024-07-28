import 'package:league_of_legends_library/core/model/rank.dart';

class Summoner {
  final String summonerId;
  final String puuid;
  final String name;
  final String tag;
  final String serverCode;
  final List<Rank> ranks;
  final int profileIconId;
  final int level;
  final String profileIconUri;

  const Summoner(
      {required this.summonerId,
      required this.puuid,
      required this.name,
      required this.tag,
      required this.serverCode,
      required this.ranks,
      required this.profileIconId,
      required this.level,
      required this.profileIconUri});
}
