import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:league_of_legends_library/data/remote_data_source.dart';

class Server implements RemoteDataSource {
  @override
  Future<Map<String, dynamic>> fetchJson(String jsonUrl) async {
    final response = await http.get(Uri.parse(jsonUrl));

    if (response.statusCode == 200) {
      final String jsonString = response.body;
      return jsonDecode(jsonString);
    } else {
      throw Exception(
          "Unable to retrieve data! Error: ${response.statusCode} - ${response.body}");
    }
  }
}