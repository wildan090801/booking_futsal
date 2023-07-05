import 'package:booking_futsal/riverpods/auth_provider.dart';
import 'package:booking_futsal/ui/admin/admin_home_screen.dart';
import 'package:booking_futsal/ui/auth/sign_in_screen.dart';
import 'package:booking_futsal/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          if (user.email == 'admin@mail.com') {
            return const AdminHomeScreen();
          } else {
            return MainScreen();
          }
        } else {
          return const SignInScreen();
        }
      },
      error: (e, trace) => const SignInScreen(),
      loading: () => const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
