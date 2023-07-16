import 'package:booking_futsal/controller/user_controller.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static Future<void> signIn(BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final navigator = Navigator.of(context);
      final email = ref.read(emailControllerTextProvider).text;
      final password = ref.read(passwordControllerTextProvider).text;
      final auth = ref.read(authProvider);

      await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = auth.currentUser;
      await UserController.getUserProfile(ref, user?.email);

      // Simpan informasi sign-in pengguna
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      navigator.pushReplacementNamed('/main-screen');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorPopupFlushbar(context, 'User tidak ditemukan!');
      } else if (e.code == 'wrong-password') {
        showErrorPopupFlushbar(context, 'Kata sandi salah!');
      } else {
        showErrorPopupFlushbar(
          context,
          'Email dan Kata Sandi harap diisi dengan benar!',
        );
      }
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  static Future<void> signUp(BuildContext context, WidgetRef ref) async {
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

      navigator.pushReplacementNamed('/main-screen');
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

  static void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
