// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationModel _$RecommendationModelFromJson(Map<String, dynamic> json) =>
    RecommendationModel(
      city: json['city'] as String,
      country: json['country'] as String,
      date: json['date'] as String,
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => PlaceRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecommendationModelToJson(
  RecommendationModel instance,
) => <String, dynamic>{
  'city': instance.city,
  'country': instance.country,
  'date': instance.date,
  'recommendations': instance.recommendations,
};

PlaceRecommendation _$PlaceRecommendationFromJson(Map<String, dynamic> json) =>
    PlaceRecommendation(
      name: json['name'] as String,
      type: json['type'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      weather: WeatherData.fromJson(json['weather'] as Map<String, dynamic>),
      recommendationText: json['recommendationText'] as String,
    );

Map<String, dynamic> _$PlaceRecommendationToJson(
  PlaceRecommendation instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'weather': instance.weather,
  'recommendationText': instance.recommendationText,
};

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
  condition: json['condition'] as String,
  temperature: json['temperature'] as String,
  wind: json['wind'] as String,
  precipitationChance: json['precipitationChance'] as String,
);

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'condition': instance.condition,
      'temperature': instance.temperature,
      'wind': instance.wind,
      'precipitationChance': instance.precipitationChance,
    };
