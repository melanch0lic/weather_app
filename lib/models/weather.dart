import 'package:json_annotation/json_annotation.dart';

import 'condition.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  @JsonKey(name: 'temp_c')
  final double tempCelsies;

  final Condition condition;

  Weather({required this.tempCelsies, required this.condition});

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}
