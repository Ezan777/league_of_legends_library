import 'package:firebase_auth/firebase_auth.dart';
import 'package:league_of_legends_library/data/user_local_data_source.dart';

class FirebaseLocalUserData implements UserLocalDataSource {
  @override
  String? getCurrentlyLoggedUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}
