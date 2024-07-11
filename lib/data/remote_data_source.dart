abstract class RemoteDataSource {
  Future<Map<String, dynamic>> fetchJson(String jsonUrl);
  Future<void> checkConnection();
}

class InternetConnectionUnavailable implements Exception {}
