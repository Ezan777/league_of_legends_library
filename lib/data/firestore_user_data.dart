import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';
import 'package:league_of_legends_library/data/remote_data_source.dart';
import 'package:league_of_legends_library/data/user_remote_data_source.dart';

class FirestoreUserData with RemoteDataSource implements UserRemoteDataSource {
  final usersCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final doc = await usersCollection.doc(userId).get();
    final data = doc.data();
    if (data != null) {
      return data;
    } else {
      throw UserNotFound();
    }
  }

  @override
  Future<void> saveUserData(AppUser user) async {
    final firestoreUser = <String, dynamic>{
      "id": user.id,
      "email": user.email,
      "name": user.name,
      "surname": user.surname,
      "summonerName": user.summonerName,
      "tagLine": user.tagLine,
      "serverCode": user.serverCode,
    };

    await usersCollection.doc(user.id).set(firestoreUser);
  }

  @override
  Future<void> deleteUserData(AppUser user) async {
    await usersCollection.doc(user.id).delete();
  }
}
