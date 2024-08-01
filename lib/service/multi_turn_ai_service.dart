import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final GenerativeModel _model;

  AIService._(this._model);

  static Future<AIService> create() async {
    final apiKey = Platform.environment['API_KEY'];
    if (apiKey == null) {
      throw Exception('No \$API_KEY environment variable');
    }
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 100),
    );
    return AIService._(model);
  }

  Future<String> sendMessage(String message) async {
    var content = Content.text(message);
    var response = await _model.generateContent([content]);
    if (response.text != null) {
      return response.text ?? " ";
    } else {
      throw Exception('Failed to generate response');
    }
  }
}
