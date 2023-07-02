import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    'Daftar',
                    style: blackTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Daftar untuk memiliki akun',
                    style: greyTextStyle.copyWith(),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  CustomFormField(
                    controller: _nameController,
                    title: 'Nama Lengkap',
                    hintText: 'Masukkan Nama Lengkap',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomFormField(
                    controller: _emailController,
                    title: 'Email',
                    hintText: 'Masukkan Email',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomFormField(
                    controller: _passwordController,
                    title: 'Kata Sandi',
                    hintText: 'Masukkan Kata Sandi',
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButton(
                    text: 'Daftar',
                    onPressed: _signUpWithEmailAndPassword,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah mempunyai akun?',
                        style: greyTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/sign-in');
                        },
                        child: Text(
                          'Masuk',
                          style: blueTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUpWithEmailAndPassword() async {
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

      navigator.pop();
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
