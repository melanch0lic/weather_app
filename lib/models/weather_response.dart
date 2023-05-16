import 'package:json_annotation/json_annotation.dart';

import 'location.dart';
import 'weather.dart';

part 'weather_response.g.dart';

@JsonSerializable()
class WeatherResponse {
  final Location location;
  final Weather current;

  WeatherResponse({required this.location, required this.current});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) => _$WeatherResponseFromJson(json);
}
