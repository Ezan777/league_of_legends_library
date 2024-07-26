class Rank {
  final String tier;
  final String rank;
  final int leaguePoints;
  final QueueType queueType;
  final int wins;
  final int losses;

  const Rank({
    required this.tier,
    required this.rank,
    required this.leaguePoints,
    required this.queueType,
    required this.wins,
    required this.losses,
  });
}

enum QueueType {
  soloDuo,
  flex;
}
