import 'dart:io';

import 'package:http/http.dart';
import 'package:Wandering/preference_data.dart';

class GenAIModel {
  final String apiUrl = '';
  final String model;
  final String prompt;
  final Map<String, dynamic> config;

  GenAIModel({
    required this.model,
    required this.prompt,
    this.config = const {},
  });

  // Future<Response> getRecommendations(UserPreferences userPreferences) async {
  //   // call gemini API, input the user preferences and get the recommendations

  //   var httpClient = HttpClient();
  //   var request = await httpClient.postUrl(Uri.parse(apiUrl));
  //   request.headers.set('Content-Type', 'application/json');

  // }
}
