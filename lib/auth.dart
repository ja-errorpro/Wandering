import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Errorlog {
  success,
  not_register_error,
  network_error,
  firebase_error,
  basic_error,
}

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthModel() {
    _auth.authStateChanges().listen((User? user) {
      print('recieved Changes: user = $user');
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  bool get isAuthenticated => user != null;

  Future<Errorlog> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return Errorlog.success;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.message!.contains('network-error')) {
          print('Network error detected');

          // Handle network error
          return Errorlog.network_error;
        } else if (e.message!.contains('no user record corresponding')) {
          print('not register yet');
          // Handle network error
          return Errorlog.not_register_error;
        } else {
          print('Firebase Login Error : ${e.message}');
          // Handle other errors
          return Errorlog.firebase_error;
        }
      } else {
        print('Basic Login Error : $e');
        return Errorlog.basic_error;
      }
    }
  }

  Future<void> register(
    BuildContext context,
    String username,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      await user?.updateDisplayName(username);

      print('userCredential : $userCredential');
      print('credential : $credential');
      print('result : $result');
      print('Current user after registration: ${_auth.currentUser}');
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      print('register Error: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
