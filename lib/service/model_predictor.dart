import 'dart:convert';
import 'package:http/http.dart' as http;

class ModelPredictor {
  static const String baseUrl = 'https://crop-yield-b2hk.onrender.com';

  Future<double> predictYield(double soil, double seed, double fertilizer, double sunny, double rainfall, double irrigation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'soil': soil,
        'seed': seed,
        'fertilizer': fertilizer,
        'sunny': sunny,
        'rainfall': rainfall,
        'irrigation': irrigation,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['predicted_yield'];
    } else {
      throw Exception('Failed to predict yield');
    }
  }
}
