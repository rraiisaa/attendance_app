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

  // get current user = buat ngabil nama user (misalnya halo! @user, mau makan apa hari ini?) 
  User? get currentUser => _auth.currentUser;

  // auth state changes stream = loginnya sekali aja, jadi ga usah login terus tiap buka app
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // sign in gmail and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    // kenapa pakai async? = karena dia menunggu pengecekan (ada proses menunggu), dia (frontend) ngobrol dulu sama firebase (frontend ngasih data user ke database)
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
    } catch (e) {
      // kalo rethrow dia masukin ulang email dan passwordnya
      rethrow;
    }
  }

  // register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    } catch (e) {
      if (e is FirebaseAuthException) { // kalo error nya dari firebase
        if (e.code == 'operation-not-allowed') { // ini disebut nested if = if bercabang/bertumpuk
          throw Exception('Email/Password accounts are not enabled. Please contact support.');
        }
      }
      rethrow; // kalo misalnya errornya bukan dari firebase, dia masukin ulang
    }
  }

  // sign out 
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}