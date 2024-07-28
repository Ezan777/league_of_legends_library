abstract class AssetsDataSource {
  Future<Map<String, dynamic>> fetchJson(String jsonUrl);
  String getProfileIconUri(String profileIconId);
  String getTierIconUri(String tier);
}

class InternetConnectionUnavailable implements Exception {}
