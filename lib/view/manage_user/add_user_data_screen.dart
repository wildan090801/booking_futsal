import 'package:booking_futsal/controller/user_controller.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserDataScreen extends ConsumerWidget {
  const AddUserDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final nameController = ref.watch(nameControllerTextProvider);
    final emailController = ref.watch(emailControllerTextProvider);
    final passwordController = ref.watch(passwordControllerTextProvider);

    nameController.text = '';
    emailController.text = '';
    passwordController.text = '';

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
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    controller: nameController,
                    title: 'Nama Lengkap',
                    hintText: 'Masukkan Nama Lengkap',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomFormField(
                    controller: emailController,
                    title: 'Email',
                    hintText: 'Masukkan Email',
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
                    text: 'Tambah',
                    onPressed: () => UserController.addUser(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
