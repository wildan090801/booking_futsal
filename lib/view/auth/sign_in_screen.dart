import 'package:booking_futsal/controller/auth_controller.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController =
        ref.watch(emailControllerTextProvider);
    final TextEditingController passwordController =
        ref.watch(passwordControllerTextProvider);

    emailController.text = '';
    passwordController.text = '';

    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollBehaviorWithoutGlow(),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Consumer(
                builder: (context, ref, _) {
                  final isLoading = ref.watch(isLoadingProvider);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading)
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
                        controller: emailController,
                        title: 'Email',
                        hintText: 'Masukkan Email',
                      ),
                      const SizedBox(height: 25),
                      CustomFormField(
                        controller: passwordController,
                        title: 'Kata Sandi',
                        hintText: 'Masukkan Kata Sandi',
                        isPassword: true,
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        text: 'Masuk',
                        onPressed: () async {
                          ref.read(isLoadingProvider.notifier).state = true;
                          await AuthController.signIn(context, ref);
                          ref.read(isLoadingProvider.notifier).state = false;
                        },
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
}
