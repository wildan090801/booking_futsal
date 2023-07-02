import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Authentication Service Provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

//Booking state
final selectedField = StateProvider<String?>((ref) => null);
final selectedDate = StateProvider<DateTime>((ref) => DateTime.now());
final selectedTimeSlot = StateProvider((ref) => -1);
