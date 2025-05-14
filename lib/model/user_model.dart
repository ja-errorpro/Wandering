import 'package:Wandering/preference_data.dart';
import 'place_model.dart';

class UserModel {
  final int uid;
  final String username;
  final String email;
  final UserPreferences preferences;
  List<PlaceModel> favoritePlaces = [];

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.preferences,
    this.favoritePlaces = const [],
  });

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'preferences': preferences.toMap(),
      'favoritePlaces': favoritePlaces.map((place) => place.toMap()).toList(),
    };
  }

  // Convert Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
      preferences: UserPreferences.fromMap(map['preferences']),
      favoritePlaces: (map['favoritePlaces'] as List)
          .map((place) => PlaceModel.fromMap(place))
          .toList(),
    );
  }

  void addFavoritePlace(PlaceModel place) {
    favoritePlaces.add(place);
  }

  bool removeFavoritePlace(PlaceModel place) {
    return favoritePlaces.remove(place);
  }
}
