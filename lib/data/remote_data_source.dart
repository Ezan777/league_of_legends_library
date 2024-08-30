import 'package:connectivity_plus/connectivity_plus.dart';

mixin RemoteDataSource {
  Future<void> checkConnection() async {
    final connection = await Connectivity().checkConnectivity();
    if (connection.firstOrNull == ConnectivityResult.none) {
      throw InternetConnectionUnavailable();
    }
  }
}

class InternetConnectionUnavailable implements Exception {
  @override
  String toString() => "Internet connection unavailable";
}
