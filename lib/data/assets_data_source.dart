abstract class AssetsDataSource {
  Future<Map<String, dynamic>> fetchJson(String jsonUrl);
}

class InternetConnectionUnavailable implements Exception {}
