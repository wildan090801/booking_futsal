import 'package:booking_futsal/model/field_model.dart';
import 'package:booking_futsal/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Authentication Service Provider
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = FirebaseAuth.instance;
  return auth.idTokenChanges();
});

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
});

final userInformation = StateProvider((ref) => UserModel());

//Booking state
final selectedField = StateProvider((ref) => FieldModel());
final selectedDate = StateProvider((ref) => DateTime.now());
final selectedTimeSlot = StateProvider((ref) => -1);
final selectedTime = StateProvider((ref) => '');

final isSearchingHistoryProvider = StateProvider<bool>((ref) => false);
final searchHistoryTextProvider = StateProvider<String>((ref) => '');
final isSearchingUserProvider = StateProvider<bool>((ref) => false);
final searchUserTextProvider = StateProvider<String>((ref) => '');
