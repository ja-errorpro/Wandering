import 'package:Wandering/preference_data.dart';

class UserModel {
  final int uid;
  final String username;
  final String email;
  final UserPreferences preferences;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.preferences,
  });

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'preferences': preferences.toMap(),
    };
  }
}
