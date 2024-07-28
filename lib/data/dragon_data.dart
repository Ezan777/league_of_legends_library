import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:league_of_legends_library/data/assets_data_source.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';

class DragonData implements AssetsDataSource, RemoteDataSource {
  final String _baseUrl = "https://league-of-legends-library.web.app";

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
  Future<void> checkConnection() async {
    final connection = await Connectivity().checkConnectivity();
    if (connection.firstOrNull == ConnectivityResult.none) {
      throw InternetConnectionUnavailable();
    }
  }

  @override
  String getProfileIconUri(String profileIconId) =>
      "$_baseUrl/14.7.1/img/profileicon/$profileIconId.png";

  @override
  String getTierIconUri(String tier) =>
      "$_baseUrl/rankedEmblems/${tier.toLowerCase()}.png";
}
