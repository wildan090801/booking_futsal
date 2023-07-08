import 'package:booking_futsal/model/booking_model.dart';
import 'package:booking_futsal/model/user_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return UserModel(name: '', email: '');
  }
}

Future<List<BookingModel>> getUserHistory() async {
  var listBooking = List<BookingModel>.empty(growable: true);
  var userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('booking_history');
  var snapshot = await userRef.orderBy('timeStamp').get();
  for (var element in snapshot.docs) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  }
  return listBooking;
}
