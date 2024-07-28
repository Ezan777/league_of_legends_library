class Rank implements Comparable<Rank> {
  final String tier;
  final String rank;
  final int leaguePoints;
  final QueueType queueType;
  final int wins;
  final int losses;
  final String tierIconUri;

  const Rank({
    required this.tier,
    required this.rank,
    required this.leaguePoints,
    required this.queueType,
    required this.wins,
    required this.losses,
    required this.tierIconUri,
  });

  @override
  int compareTo(other) {
    if (queueType == other.queueType) {
      return 0;
    } else if (queueType == QueueType.soloDuo &&
        other.queueType == QueueType.flex) {
      return -1;
    } else {
      return 1;
    }
  }
}

enum QueueType {
  soloDuo,
  flex;
}
