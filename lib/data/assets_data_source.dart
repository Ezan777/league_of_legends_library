abstract class AssetsDataSource {
  Future<Map<String, dynamic>> fetchJson(String jsonUrl);
  String getProfileIconUri(String profileIconId);
}

class InternetConnectionUnavailable implements Exception {}
