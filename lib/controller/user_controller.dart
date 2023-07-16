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
