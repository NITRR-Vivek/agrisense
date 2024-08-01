import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ApiService {

  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  static Future<String> sendMessage(String message) async {
    final content = [Content.text(message)];
    final response = await _model.generateContent(content);

    if (response.text != null) {
      return response.text!;
    } else {
      throw Exception('Failed to generate response');
    }
  }


  static late final Dio _dio;
  static Dio get client => _dio;
  static void init() {
    _dio = Dio();
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
        () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }

  static Future<Map<String, dynamic>> getForecast15(
      double lat,
      double lon,
      String language,
      ) async {
    Response? response;
    try {
      response = await _dio.get(
        'http://api.openweathermap.org/data/2.5/forecast/daily',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'cnt': 15,
          'lang': language,
          'appid': dotenv.env['OPEN_WEATHER_API_KEY']!
        },
      );
    } on Exception catch (exception, stacktrace) {
      debugPrint('ERROR: Failed during a GET request.\n'
          'Endpoint: /data/2.5/forecast/daily\n'
          'Exception: $exception\nStacktrace: $stacktrace');
      Sentry.captureMessage('Failed to fetch 15 day forecast for ($lat, $lon)');
    }
    return {
      'status_code': response?.statusCode ?? 0,
      'data': response?.data ?? 'null',
    };
  }

  static Future<Map<String, dynamic>> getForecast5(
      double lat,
      double lon,
      String language,
      ) async {
    Response? response;
    try {
      response = await _dio.get(
        'http://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'lang': language,
          'appid': dotenv.env['OPEN_WEATHER_API_KEY']!
        },
      );
    } on Exception catch (exception, stacktrace) {
      debugPrint('ERROR: Failed during a GET request.\n'
          'Endpoint: /data/2.5/forecast\n'
          'Exception: $exception\nStacktrace: $stacktrace');
      Sentry.captureMessage('Failed to fetch 5 day forecast for ($lat, $lon)');
    }
    return {
      'status_code': response?.statusCode ?? 0,
      'data': response?.data ?? 'null',
    };
  }

  static Future<Map<String, dynamic>> getPrices(
      String? pincode,
      String? district,
      ) async {
    Response? response;
    try {
      response =
      await _dio.get('https://api.postalpincode.in/pincode/$pincode');

      if (response.data[0]["Status"] != "Success") {
        throw Exception("couldn't fetch location data for $pincode");
      }

      final firstPostOffice = response.data[0]["PostOffice"][0];

      response = await _dio.get(
        'http://170.187.249.130:5000/get_data',
        queryParameters: {
          'state': firstPostOffice["State"],
        },
      );

      if (response.data["status"] != "success") {
        throw Exception("couldn't fetch crop prices");
      }
    } on Exception catch (exception, stacktrace) {
      debugPrint('ERROR: Failed during a GET request.\n'
          'Endpoint: /get_data\n'
          'Exception: $exception\nStacktrace: $stacktrace');
      Sentry.captureMessage('Failed to fetch crop prices for $pincode');
    }
    return {
      'status_code': response?.statusCode ?? 0,
      'data': response?.data ?? 'null',
    };
  }
}
