abstract class AssetsDataSource {
  Future<Map<String, dynamic>> fetchJson(String jsonUrl);
  String getProfileIconUri(String profileIconId);
  String getTierIconUri(String tier);
  String getIemTileUri(String itemId);
  String getSummonerSpellTileBySpellId(String spellId);
  String getChampionTileUri(String championId, {int skinCode = 0});
}
