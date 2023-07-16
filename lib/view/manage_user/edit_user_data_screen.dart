import 'package:booking_futsal/controller/user_controller.dart';
import 'package:booking_futsal/model/user_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditUserDataScreen extends ConsumerWidget {
  final UserModel user;

  const EditUserDataScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final nameController = ref.read(nameControllerTextProvider);
    final emailController = ref.read(emailControllerTextProvider);
    final passwordController = ref.read(passwordControllerTextProvider);

    nameController.text = user.name ?? '';
    emailController.text = user.email ?? '';
    passwordController.text = user.password ?? '';

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
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  isEdit: true,
                  controller: emailController,
                  title: 'Email',
                  hintText: 'Masukkan Email',
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFormField(
                  title: 'Nama Lengkap',
                  hintText: 'Masukkan Nama Lengkap',
                  controller: nameController,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFormField(
                  controller: passwordController,
                  title: 'Kata Sandi',
                  hintText: 'Masukkan Kata Sandi',
                  isPassword: true,
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  text: 'Simpan',
                  onPressed: isLoading
                      ? null
                      : () => UserController.editUser(context, ref),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
