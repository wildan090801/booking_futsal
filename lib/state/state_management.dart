import 'package:booking_futsal/model/field_model.dart';
import 'package:booking_futsal/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

final selectedHistoryDate = StateProvider((ref) => DateTime.now());
final isSearchingHistoryProvider = StateProvider<bool>((ref) => false);
final searchHistoryTextProvider = StateProvider<String>((ref) => '');
final isSearchingUserProvider = StateProvider<bool>((ref) => false);
final searchUserTextProvider = StateProvider<String>((ref) => '');

final nameControllerTextProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final emailControllerTextProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final passwordControllerTextProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final isLoadingProvider = StateProvider<bool>((ref) => false);
