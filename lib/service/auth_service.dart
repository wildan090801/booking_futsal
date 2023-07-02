import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Metode untuk melakukan sign-in dengan email dan password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Metode untuk mendapatkan peran pengguna berdasarkan email
  String getUserRole(String email) {
    // Contoh implementasi, dapat disesuaikan dengan kebutuhan aplikasi
    if (email == 'admin@mail.com') {
      return 'admin';
    } else {
      return 'customer';
    }
  }
}
