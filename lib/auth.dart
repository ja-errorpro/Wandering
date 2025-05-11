import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.message!.contains('network-error')) {
          print('Network error detected');
          // Handle network error
        } else if (e.message!.contains('no user record corresponding')) {
          print('not register yet');
          // Handle network error
        } else {
          print('Firebase Login Error : ${e.message}');
          // Handle other errors
        }
      } else {
        print('Basic Login Error : $e');
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
