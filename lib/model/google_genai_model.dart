import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:Wandering/preference_data.dart';

class GenAIModel {
  final String apiUrl = 'http://gemini-api.hopto.org:8000/generate';
  final Map<String, dynamic> config;

  GenAIModel({this.config = const {}});

  Future<String> getOneRecommendation(
    List<UserPreferences> userPreferences,
  ) async {
    // call gemini API, input the user preferences and get the recommendations

    var httpClient = HttpClient();
    var request = await httpClient.postUrl(Uri.parse(apiUrl));
    List<String> travelStyles = [];

    for (var preference in userPreferences) {
      travelStyles.addAll(preference.travelStyles);
    }

    String prompt = '我偏好 $travelStyles，請推薦給我一些適合我的景點，有沒有其他更適合我的呢?';
    request.headers.set('Content-Type', 'application/json');
    print('prompt: $prompt');
    request.add(utf8.encode(jsonEncode({'prompt': prompt})));

    var response = await request.close(); // send the request
    if (response.statusCode == 200) {
      var responseBody = await response.transform(utf8.decoder).join();
      var jsonResponse = jsonDecode(responseBody);
      print(jsonResponse);
      if (jsonResponse['response'] != null) {
        return jsonResponse['response'];
      } else {
        throw Exception('No recommendations found');
      }
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
