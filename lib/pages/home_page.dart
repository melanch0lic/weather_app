import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/models/weather_response.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getCurrentWeather(LatLng point) async {
    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse(
        'http://api.weatherapi.com/v1/current.json?q=${point.latitude},${point.longitude}&lang=ru&key=46d58dd98dfe476285563025231605');
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
  LatLng? _currentPoint;
  bool _isEditingMode = true;
  WeatherResponse? _currentWeather;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: _isEditingMode
          ? Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    nonRotatedChildren: [
                      if (_currentPoint == null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                              child: const Text(
                                'Выберите локацию',
                                style: TextStyle(color: Colors.white, fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                      if (_currentPoint != null)
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      getCurrentWeather(_currentPoint!);
                                      _isEditingMode = false;
                                      _currentPoint = null;
                                    });
                                  },
                                  child: const Text('Получить погоду по данной локации')),
                            ))
                    ],
                    options: MapOptions(
                      keepAlive: true,
                      center: LatLng(43.0367, 44.6678),
                      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      zoom: 3,
                      onTap: (tapPosition, point) {
                        setState(() {
                          _currentPoint = point;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.de/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      if (_currentPoint != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                                point: _currentPoint!,
                                builder: (context) => const Icon(
                                      Icons.location_pin,
                                      color: Colors.purple,
                                    ))
                          ],
                        )
                    ],
                  ),
                )
              ],
            )
          : Center(
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
                        Text('Локация ${_currentWeather!.location.name}, ${_currentWeather!.location.region}'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditingMode = true;
                              });
                            },
                            child: const Text('Изменить локацию'))
                      ],
                    )),
    );
  }
}
