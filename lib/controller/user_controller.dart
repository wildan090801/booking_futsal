import 'package:booking_futsal/model/user_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController {
  static Future<void> addUser(BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final navigator = Navigator.of(context);
      final name = ref.read(nameControllerTextProvider).text;
      final email = ref.read(emailControllerTextProvider).text;
      final password = ref.read(passwordControllerTextProvider).text;
      final auth = ref.read(authProvider);
      final firestore = ref.read(firestoreProvider);

      // Membuat user menggunakan email dan password
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mendapatkan UID pengguna
      // ignore: unused_local_variable
      final String userId = userCredential.user!.uid;

      // Mendefinisikan role default sebagai 'pelanggan'
      const String defaultRole = 'pelanggan';

      // Membuat dokumen baru di koleksi "users" dengan UID sebagai ID dokumen
      await firestore.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'password': password,
        'role': defaultRole,
      });

      // Keluar dari sesi otentikasi
      await auth.signOut();

      // Mengatur ulang status login dengan akun admin setelah hot reload
      await auth.signInWithEmailAndPassword(
        email: 'admin@gmail.com',
        password: '123123',
      );

      navigator.pop();

      // ignore: use_build_context_synchronously
      showSuccessPopupFlushbar(context, 'Berhasil menambahkan data pengguna');
      // Mengatur ulang nilai TextField setelah berhasil menambahkan data
      ref.read(nameControllerTextProvider).clear();
      ref.read(emailControllerTextProvider).clear();
      ref.read(passwordControllerTextProvider).clear();
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Exception khusus Firebase Authentication
        if (e.code == 'email-already-in-use') {
          showErrorPopupFlushbar(context, 'Email telah digunakan!');
        } else if (e.code == 'invalid-email') {
          showErrorPopupFlushbar(context, 'Format email tidak valid!');
        } else if (e.code == 'operation-not-allowed') {
          showErrorPopupFlushbar(context, 'Pembuatan akun tidak diizinkan!');
        } else if (e.code == 'weak-password') {
          showErrorPopupFlushbar(context, 'Kata sandi kurang dari 6 karakter!');
        } else {
          showErrorPopupFlushbar(
              context, 'Seluruh kolom harap diisi dengan benar!');
        }
      } else {
        showErrorPopupFlushbar(context, 'Terdapat kesalahan dalam mendaftar!');
      }
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  static Future<void> editUser(BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final navigator = Navigator.of(context);
      final name = ref.read(nameControllerTextProvider).text;
      final email = ref.read(emailControllerTextProvider).text;
      final password = ref.read(passwordControllerTextProvider).text;
      final firestore = ref.read(firestoreProvider);

      if (password.isEmpty) {
        showErrorPopupFlushbar(context, 'Kata sandi tidak boleh kosong!');
        return;
      } else if (name.isEmpty) {
        showErrorPopupFlushbar(context, 'Nama Lengkap tidak boleh kosong!');
        return;
      }

      await firestore.collection('users').doc(email).update({
        'name': name,
        'email': email,
        'password': password,
      });

      navigator.pop();
      // ignore: use_build_context_synchronously
      showSuccessPopupFlushbar(context, 'Berhasil mengubah data pengguna');

      // Mengatur ulang nilai TextField setelah berhasil mengubah data
      ref.read(nameControllerTextProvider).clear();
      ref.read(emailControllerTextProvider).clear();
      ref.read(passwordControllerTextProvider).clear();
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Exception khusus Firebase Authentication
        if (e.code == 'email-already-in-use') {
          showErrorPopupFlushbar(context, 'Email telah digunakan!');
        } else if (e.code == 'invalid-email') {
          showErrorPopupFlushbar(context, 'Format email tidak valid!');
        } else if (e.code == 'operation-not-allowed') {
          showErrorPopupFlushbar(context, 'Pembuatan akun tidak diizinkan!');
        } else if (e.code == 'weak-password') {
          showErrorPopupFlushbar(context, 'Kata sandi kurang dari 6 karakter!');
        } else {
          showErrorPopupFlushbar(
              context, 'Seluruh kolom harap diisi dengan benar!');
        }
      } else {
        showErrorPopupFlushbar(context, 'Terdapat kesalahan dalam mendaftar!');
      }
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  static Future<void> deleteUser(BuildContext context, String email) async {
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

  static Future<UserModel> getUserProfile(WidgetRef ref, String? email) async {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');
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

  static Stream<List<UserModel>> getUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('name', descending: false)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => UserModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
