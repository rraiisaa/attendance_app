import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthServices () {
    if (!kIsWeb) { // !kIsWeb = only for mobile platforms
      FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false
      );

    }
  }

  // get current user
  User? get currentUser => _auth.currentUser;

  // auth state changes stream = loginnya sekali aja, jadi ga usah login terus tiap buka app
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // sign in gmail and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
    } catch (e) {
      // untuk membalikkan kembali
      rethrow;
    }
  }
}