import 'dart:convert';

class Weather {
  int temperature;
  int maxTemp;
  int minTemp;
  int humidity;
  int wind;
  int pressure;
  String? weatherIcon;
  String weatherText;
  Map<String, String> dailyTip;
  DateTime date;
  int? probabilityOfPrecipitation;
  String? cityState;

  // Constructor
  Weather({
    this.temperature = 0,
    this.maxTemp = 0,
    this.minTemp = 0,
    this.humidity = 0,
    this.wind = 0,
    this.pressure = 0,
    this.weatherIcon,
    this.weatherText = '',
    this.dailyTip = const {},
    required this.date,
    this.probabilityOfPrecipitation,
    this.cityState
  });

  // Factory method to create a Weather instance from a Map
  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      temperature: map['temperature'] ?? 0,
      maxTemp: map['maxTemp'] ?? 0,
      minTemp: map['minTemp'] ?? 0,
      humidity: map['humidity'] ?? 0,
      wind: map['wind'] ?? 0,
      pressure: map['pressure'] ?? 0,
      weatherIcon: map['weatherIcon'],
      weatherText: map['weatherText'] ?? '',
      dailyTip: Map<String, String>.from(map['dailyTip'] ?? {}),
      date: DateTime.parse(map['date']),
      probabilityOfPrecipitation: map['probabilityOfPrecipitation'],
      cityState: map['cityState'] ?? 'location...',
    );
  }

  // Method to convert Weather instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'humidity': humidity,
      'wind': wind,
      'pressure': pressure,
      'weatherIcon': weatherIcon,
      'weatherText': weatherText,
      'dailyTip': dailyTip,
      'date': date.toIso8601String(),
      'probabilityOfPrecipitation': probabilityOfPrecipitation,
      'cityState':cityState
    };
  }
  String toJson() => jsonEncode(toMap());
  factory Weather.fromJson(String source) => Weather.fromMap(jsonDecode(source));
}
