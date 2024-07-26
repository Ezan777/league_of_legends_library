import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';
import 'package:league_of_legends_library/data/user_remote_data_source.dart';

class FirestoreUserData implements UserRemoteDataSource {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final doc = await db.collection("users").doc(userId).get();
    final data = doc.data();
    if (data != null) {
      return data;
    } else {
      throw UserNotFound();
    }
  }

  @override
  Future<void> saveUserData(AppUser user) async {
    final users = db.collection("users");
    final firestoreUser = <String, dynamic>{
      "id": user.id,
      "email": user.email,
      "name": user.name,
      "surname": user.surname,
      "summonerName": user.summonerName,
      "tagLine": user.tagLine,
      "serverCode": user.serverCode,
    };

    await users.doc(user.id).set(firestoreUser);
  }
}
