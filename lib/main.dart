import 'package:booking_futsal/firebase_options.dart';
import 'package:booking_futsal/ui/screens/booking_screen.dart';
import 'package:booking_futsal/ui/screens/booking_success_screen.dart';
import 'package:booking_futsal/ui/screens/customer_information_screen.dart';
import 'package:booking_futsal/ui/screens/history_screen.dart';
import 'package:booking_futsal/ui/screens/main_screen.dart';
import 'package:booking_futsal/ui/screens/manage_field_screen.dart';
import 'package:booking_futsal/ui/screens/manage_user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ui/auth/auth_checker.dart';
import 'ui/auth/sign_in_screen.dart';
import 'ui/auth/sign_up_screen.dart';
import 'ui/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth-checker': (context) => const AuthChecker(),
        '/sign-in': (context) => const SignInScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/main-screen': (context) => MainScreen(),
        '/booking-screen': (context) => const BookingScreen(),
        '/history-screen': (context) => const HistoryScreen(),
        '/manage-field': (context) => const ManageFieldScreen(),
        '/manage-user': (context) => const ManageUserScreen(),
        '/booking-success': (context) => const BookingSuccessScreen(),
        '/information': (context) => const CustomerInformationScreen(),
      },
    );
  }
}
