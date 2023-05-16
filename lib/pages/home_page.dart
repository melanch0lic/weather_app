import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_response.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getCurrentWeather() async {
    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse(
        'http://api.weatherapi.com/v1/current.json?q=40.7143,-74.006&lang=ru&key=46d58dd98dfe476285563025231605');
    var response = await http.get(url);
    var decodedRepsonse = WeatherResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    setState(() {
      _currentWeather = decodedRepsonse;
    });

    setState(() {
      _isLoading = false;
    });
  }

  bool _isLoading = false;
  WeatherResponse? _currentWeather;

  @override
  void initState() {
    getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Center(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.scale(
                        scale: 1.8, child: Image.network('https:${_currentWeather!.current.condition.icon}')),
                    const SizedBox(height: 20),
                    Text(_currentWeather!.current.condition.text),
                    const SizedBox(height: 20),
                    Text('Температура ${_currentWeather!.current.tempCelsies} °C'),
                    const SizedBox(height: 20),
                    Text('Локация ${_currentWeather!.location.name}, ${_currentWeather!.location.region}')
                  ],
                )),
    );
  }
}
