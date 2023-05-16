import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final String name;
  final String region;

  Location({required this.name, required this.region});

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}
