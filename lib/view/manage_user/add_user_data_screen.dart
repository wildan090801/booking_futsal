import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUserDataScreen extends StatefulWidget {
  const AddUserDataScreen({super.key});

  @override
  State<AddUserDataScreen> createState() => _AddUserDataScreenState();
}

class _AddUserDataScreenState extends State<AddUserDataScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tambah Data Pelanggan',
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollBehaviorWithoutGlow(),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    controller: _nameController,
                    title: 'Nama Lengkap',
                    hintText: 'Masukkan Nama Lengkap',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomFormField(
                    controller: _emailController,
                    title: 'Email',
                    hintText: 'Masukkan Email',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomFormField(
                    controller: _passwordController,
                    title: 'Kata Sandi',
                    hintText: 'Masukkan Kata Sandi',
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButton(
                    text: 'Tambah',
                    onPressed: _addUser,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final navigator = Navigator.of(context);
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      // Membuat user menggunakan email dan password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mendapatkan UID pengguna
      // ignore: unused_local_variable
      final String userId = userCredential.user!.uid;

      // Mendefinisikan role default sebagai 'pelanggan'
      const String defaultRole = 'pelanggan';

      // Membuat dokumen baru di koleksi "users" dengan UID sebagai ID dokumen
      await _firestore.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'password': password,
        'role': defaultRole,
      });

      // Keluar dari sesi otentikasi
      await _auth.signOut();

      // Mengatur ulang status login dengan akun admin setelah hot reload
      await _auth.signInWithEmailAndPassword(
        email: 'admin@gmail.com',
        password: '123123',
      );

      navigator.pop();

      // ignore: use_build_context_synchronously
      showSuccessPopupFlushbar(context, 'Berhasil menambahkan data pengguna');
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
      setState(() {
        _isLoading = false;
      });
    }
  }
}
