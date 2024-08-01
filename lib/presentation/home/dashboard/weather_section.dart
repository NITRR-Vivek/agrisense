import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/weather.dart';
import '../../../service/weather.dart';

class WeatherSection extends StatefulWidget {
  const WeatherSection({super.key});

  @override
  WeatherSectionState createState() => WeatherSectionState();
}

class WeatherSectionState extends State<WeatherSection> {
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _getWeatherData();
  }

  Future<Weather> _getWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherJson = prefs.getString('cachedWeather');

    if (weatherJson != null) {
      return Weather.fromJson(weatherJson);
    } else {
      return _fetchWeather();
    }
  }

  Future<Weather> _fetchWeather() async {
    try {
      final weather = await WeatherService.getCurrentWeather(context, 'en');
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('cachedWeather', weather.toJson());
      return weather;
    } catch (e) {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> refreshWeather() async {
    setState(() {
      _weatherFuture = _fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildWeatherAndLocation(context, null),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading weather',
              style: TextStyle(color: Colors.blue),
            ),
          );
        } else if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildWeatherAndLocation(context, null),
          );
        } else {
          final weather = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildWeatherAndLocation(context, weather),
          );
        }
      },
    );
  }

  List<Widget> buildWeatherAndLocation(BuildContext context, Weather? model) {
    final temperature = model?.temperature.toString() ?? '0';
    final humidity = model?.humidity.toString() ?? '0';
    final weatherText = model?.weatherText ?? '';
    final weatherIcon = model?.weatherIcon;
    final cityState = model?.cityState ?? 'fetching...';

    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 30, left: 21),
        child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset('assets/images/weather/map_pin.svg', width: 16),
                Text(
                  cityState,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF949494),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
      ),
      Padding(
        padding: const EdgeInsets.only(left: 40, right: 27),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      temperature,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const Text(
                      '°C',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset('assets/images/weather/humidity.svg', width: 16),
                    Text(
                      '$humidity%',
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  DateFormat('EEE, d MMM').format(DateTime.now()),
                  style: const TextStyle(),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                if (weatherIcon != null)
                  SvgPicture.asset(
                    weatherIcon,
                    width: 90,
                  )
                else
                  const SizedBox(
                    width: 90,
                    height: 102,
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  weatherText,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
