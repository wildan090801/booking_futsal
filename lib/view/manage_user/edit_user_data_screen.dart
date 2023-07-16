import 'package:booking_futsal/model/user_model.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUserDataScreen extends StatefulWidget {
  final UserModel user;

  const EditUserDataScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserDataScreen> createState() => _EditUserDataScreenState();
}

class _EditUserDataScreenState extends State<EditUserDataScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? '';
    _emailController.text = widget.user.email ?? '';
    _passwordController.text = widget.user.password ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ubah Data Pelanggan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
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
                  isEdit: true,
                  controller: _emailController,
                  title: 'Email',
                  hintText: 'Masukkan Email',
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFormField(
                  title: 'Nama Lengkap',
                  hintText: 'Masukkan Nama Lengkap',
                  controller: _nameController,
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
                  text: 'Simpan',
                  onPressed: _isLoading ? null : _updateUser,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final navigator = Navigator.of(context);
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      if (password.isEmpty) {
        showErrorPopupFlushbar(context, 'Kata sandi tidak boleh kosong!');
        return;
      } else if (name.isEmpty) {
        showErrorPopupFlushbar(context, 'Nama Lengkap tidak boleh kosong!');
        return;
      }

      await _firestore.collection('users').doc(email).update({
        'name': name,
        'email': email,
        'password': password,
      });

      navigator.pop();
      // ignore: use_build_context_synchronously
      showSuccessPopupFlushbar(context, 'Berhasil mengubah data pengguna');
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
