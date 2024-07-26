class SummonerDto {
  final String id;
  final String puuid;
  final int profileIconId;
  final int summonerLevel;

  const SummonerDto({
    required this.id,
    required this.puuid,
    required this.profileIconId,
    required this.summonerLevel,
  });

  factory SummonerDto.fromJson(Map<String, dynamic> json) {
    return SummonerDto(
      id: json['id'],
      puuid: json['puuid'],
      profileIconId: json['profileIconId'],
      summonerLevel: json['summonerLevel'],
    );
  }
}
