import 'package:booking_futsal/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<UserModel> getUserProfiles(String? email) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot snapshot = await userRef.doc(email).get();
  if (snapshot.exists) {
    final data = snapshot.data() as Map<String, dynamic>;
    var userModel = UserModel.fromJson(data);
    return userModel;
  } else {
    return UserModel(name: '', email: '');
  }
}
