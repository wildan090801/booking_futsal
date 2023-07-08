import 'package:booking_futsal/cloud_firestore/user_ref.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollBehaviorWithoutGlow(),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Consumer(
                builder: (context, ref, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator()),
                      Text(
                        'Masuk',
                        style: blackTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Masuk untuk melanjutkan',
                        style: greyTextStyle,
                      ),
                      const SizedBox(height: 35),
                      const Hero(
                        tag: 'logo',
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo_haphap.png'),
                            radius: 90,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomFormField(
                        controller: _emailController,
                        title: 'Email',
                        hintText: 'Masukkan Email',
                      ),
                      const SizedBox(height: 25),
                      CustomFormField(
                        controller: _passwordController,
                        title: 'Kata Sandi',
                        hintText: 'Masukkan Kata Sandi',
                        isPassword: true,
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        text: 'Masuk',
                        onPressed: () async =>
                            await _signInWithEmailAndPassword(ref),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tidak mempunyai akun?',
                            style: greyTextStyle.copyWith(fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign-up');
                            },
                            child: Text(
                              'Daftar',
                              style: blueTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(WidgetRef ref) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final navigator = Navigator.of(context);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = _auth.currentUser;
      await getUserProfiles(ref, user?.email);

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
      setState(() {
        _isLoading = false;
      });
    }
  }
}
