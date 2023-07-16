import 'package:booking_futsal/controller/auth_controller.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

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
                    controller: nameController,
                    title: 'Nama Lengkap',
                    hintText: 'Masukkan Nama Lengkap',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomFormField(
                    controller: emailController,
                    title: 'Email',
                    hintText: 'Masukkan Email',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomFormField(
                    controller: passwordController,
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
                    onPressed: () => AuthController.signUp(context, ref),
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
}
