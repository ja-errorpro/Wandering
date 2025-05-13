import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Errorlog {
  success,
  not_register_error,
  network_error,
  firebase_error,
  basic_error,
}

class LoginError implements Exception {
  final Errorlog error;
  final String message;
  LoginError(this.error, this.message);
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

  Future<LoginError> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return LoginError(Errorlog.success, 'Login successful');
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.message!.contains('network error')) {
          print('Network error detected');

          // Handle network error
          return LoginError(Errorlog.network_error, '錯誤：請檢查網路連線');
        } else if (e.message!.contains('no user record corresponding')) {
          print('not register yet');
          // Handle network error
          return LoginError(Errorlog.not_register_error, '錯誤：此帳號尚未註冊');
        } else {
          print('Firebase Login Error : ${e.message}');
          // Handle other errors
          return LoginError(Errorlog.firebase_error, '錯誤: 請檢查帳號或密碼');
        }
      } else {
        print('Basic Login Error : $e');
        return LoginError(Errorlog.basic_error, '錯誤: $e');
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
