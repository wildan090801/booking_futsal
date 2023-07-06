import 'package:booking_futsal/model/booking_model.dart';
import 'package:booking_futsal/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Authentication Service Provider
final authProvider = StateProvider((ref) => false);

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final userInformation = StateProvider((ref) => UserModel());

//Booking state
final selectedField = StateProvider((ref) => BookingModel());
final selectedDate = StateProvider((ref) => DateTime.now());
final selectedTimeSlot = StateProvider((ref) => -1);
final selectedTime = StateProvider((ref) => '');
