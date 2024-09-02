import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:league_of_legends_library/data/assets_data_source.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';

class DragonData with RemoteDataSource implements AssetsDataSource {
  final String _baseUrl = "https://league-of-legends-library.web.app";
  final String _version = "14.7.1";

  @override
  Future<Map<String, dynamic>> fetchJson(String jsonUrl) async {
    await checkConnection();

    final response = await http.get(
      Uri.parse(jsonUrl),
    );

    if (response.statusCode == 200) {
      final String jsonString = utf8.decode(response.bodyBytes);
      return jsonDecode(jsonString);
    } else {
      throw Exception(
          "Unable to retrieve data! Error: ${response.statusCode} - ${response.body}");
    }
  }

  @override
  String getProfileIconUri(String profileIconId) =>
      "$_baseUrl/$_version/img/profileicon/$profileIconId.png";

  @override
  String getTierIconUri(String tier) =>
      "$_baseUrl/rankedEmblems/${tier.toLowerCase()}.png";

  @override
  String getItemTileUri(String itemId) =>
      "$_baseUrl/$_version/img/item/$itemId.png";

  @override
  String getSummonerSpellTileBySpellId(String spellId) =>
      "$_baseUrl/$_version/img/spell/$spellId.png";

  @override
  String getChampionTileUri(String championId, {int skinCode = 0}) {
    // This is needed because Fiddlesticks images are broken and named FiddleSticks...
    if (championId == "Fiddlesticks") {
      championId = "FiddleSticks";
    }
    return "$_baseUrl/img/champion/tiles/${championId}_$skinCode.jpg";
  }
}
