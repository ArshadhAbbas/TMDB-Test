import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tmdb_app/model/custom_user.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CustomUser? _userFromFireBase(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  Stream<CustomUser?> get user {
    return auth.authStateChanges().map(
      (user) {
        final customUser = _userFromFireBase(user);
        if (kDebugMode) {
          print("User state changed: ${customUser?.uid}");
        }
        return customUser;
      },
    );
  }

  Future signOut() async {
    try {
      await auth.signOut();
      if (kDebugMode) {
        print("User signed out");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Sign out error: $e");
      }
    }
  }
}
