import 'package:http/http.dart';

class GenAIModel {
  final String apiKey;
  final String apiUrl = '';
  final String model;
  final String prompt;
  final Map<String, dynamic> config;

  GenAIModel({
    required this.apiKey,
    required this.model,
    required this.prompt,
    this.config = const {},
  });
}
