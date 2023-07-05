import 'package:booking_futsal/model/user_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<UserModel> getUserProfiles(WidgetRef ref, String? email) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot snapshot = await userRef.doc(email).get();
  if (snapshot.exists) {
    final data = snapshot.data() as Map<String, dynamic>;
    var userModel = UserModel.fromJson(data);
    ref.read(userInformation.notifier).state = userModel;
    return userModel;
  } else {
    return UserModel(name: '', email: '', role: '');
  }
}
