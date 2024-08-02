import 'dart:convert';
import 'package:http/http.dart' as http;

class ModelPredictor {
  static const String baseUrl = 'https://crop-yield-b2hk.onrender.com';

  Future<double> predictYield(double soil, double seed, double fertilizer, double sunny, double rainfall, double irrigation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict/'),  // Ensure there's a trailing slash
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'Soil_Quality': soil,
        'Seed_Variety': seed,
        'Fertilizer_Amount_kg_per_hectare': fertilizer,
        'Sunny_Days': sunny,
        'Rainfall_mm': rainfall,
        'Irrigation_Schedule': irrigation,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return double.parse(jsonResponse['predicted_yield']);
    } else {
      throw Exception('Failed to predict yield');
    }
  }
}
