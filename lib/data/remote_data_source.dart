abstract class RemoteDataSource {
  Future<Map<String, dynamic>> fetchJson(String jsonUrl);
}
