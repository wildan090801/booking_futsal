import 'package:booking_futsal/model/booking_model.dart';
import 'package:booking_futsal/model/user_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> deleteUser(BuildContext context, String email) async {
  try {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    // Hapus pengguna dari Firebase Authentication
    final currentUser = auth.currentUser;
    if (currentUser != null && currentUser.email == email) {
      await currentUser.delete();
    }

    // Hapus data pengguna dari Firestore
    await firestore.collection('users').doc(email).delete();

    // Tampilkan pesan sukses
    // ignore: use_build_context_synchronously
    showSuccessPopupFlushbar(context, 'Berhasil menghapus data pengguna');
  } catch (e) {
    // Tampilkan pesan error
    showErrorPopupFlushbar(
        context, 'Terdapat kesalahan dalam menghapus pengguna');
  }
}

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
    var booking = BookingModel.fromJson(element.data(), element.id);
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  }
  return listBooking;
}

Future<List<BookingModel>> getAllBookingHistory() async {
  List<BookingModel> bookingHistory = [];
  try {
    // Membaca semua dokumen user
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Mengambil riwayat booking dari setiap user
    for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
      // Mengambil koleksi 'booking_history' dari user saat ini
      CollectionReference bookingHistoryRef =
          userDoc.reference.collection('booking_history');

      // Membaca semua riwayat booking
      QuerySnapshot bookingSnapshot = await bookingHistoryRef.get();

      // Menambahkan riwayat booking ke daftar bookingHistory
      for (QueryDocumentSnapshot bookingDoc in bookingSnapshot.docs) {
        bookingHistory.add(
          BookingModel.fromJson(
            bookingDoc.data() as Map<String,
                dynamic>, // Melakukan casting data menjadi Map<String, dynamic>
            bookingDoc.id,
          ),
        );
      }
    }
  } catch (error) {
    Text('Terjadi kesalahan saat mengambil riwayat booking: $error');
  }
  return bookingHistory;
}
