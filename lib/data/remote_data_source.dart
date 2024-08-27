abstract class RemoteDataSource {
  Future<void> checkConnection();
}

class InternetConnectionUnavailable implements Exception {}
