import 'package:json_annotation/json_annotation.dart';

part 'recommendation_model.g.dart';

@JsonSerializable()
class RecommendationModel {
  final String city;
  final String country;
  final String date;
  final List<PlaceRecommendation> recommendations;

  RecommendationModel({
    required this.city,
    required this.country,
    required this.date,
    required this.recommendations,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationModelToJson(this);
}

@JsonSerializable()
class PlaceRecommendation {
  final String name;
  final String type; // Например: 'Природная достопримечательность', 'Музей', 'Кафе'
  final double latitude;
  final double longitude;
  final String weather;
  // final WeatherData weather;
  final String recommendationText; // Советы (одежда, что взять и т.п.)

  PlaceRecommendation({
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.weather,
    required this.recommendationText,
  });

  factory PlaceRecommendation.fromJson(Map<String, dynamic> json) =>
      _$PlaceRecommendationFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceRecommendationToJson(this);
}

@JsonSerializable()
class WeatherData {
  final String condition; // Например: 'Солнечно', 'Снег', 'Облачно'
  final String temperature; // Например: "+5°C"
  final String wind; // Например: "15 км/ч"
  final String precipitationChance; // Например: "70%"

  WeatherData({
    required this.condition,
    required this.temperature,
    required this.wind,
    required this.precipitationChance,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}

class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});  
  
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int, // Assuming 'id' is an integer field
      name: json['name'] as String, // Assuming 'name' is a string field
    );
  }
}

class City {
  final int id;
  final int countryId;
  final String name;
  City({required this.id, required this.countryId, required this.name});

    
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      countryId: json['countryId'] as int,
      name: json['name'] as String,
    );
  }

}