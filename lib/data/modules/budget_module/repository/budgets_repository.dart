import 'dart:convert';
import 'dart:developer';
import 'package:demalu/data/api/dio_client.dart';
import 'package:demalu/data/modules/budget_module/models/recommendation_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:demalu/data/api/api_config.dart';


class BudgetsRepository {
  final gemini = Gemini.instance;
  final DioClient _dioClient = DioClient();

  Future<RecommendationModel?> getRecommendations(String country, String city, DateTime date, int minPrice, int maxPrice, String? activityType) async {
    try {
      final userPrompt = 
          "Сгенерируй JSON-массив рекомендаций мест для посещения."
          "Контекст Страна: $country. Город: $city, Минимальный бюджет: $minPrice и максимальный бюджет $maxPrice"
          "Дата: ${date.toIso8601String().substring(0, 10)}. "
          "Тип активности: $activityType"
          """Ответ в формате JSON: 
          {
            "city": "$city",
            "country": "$country",
            "date": "${date.toIso8601String().substring(0, 10)}",
            "recommendations": [
                {
                  "name": "Название места",
                  "type": "Тип места (например: 'Природная достопримечательность', 'Музей', 'Кафе')",
                  "latitude": 0.00, // Числовой формат!
                  "longitude": 0.00, // Числовой формат!
                  "weather": "Краткое описание погоды (например, 'Солнечно, +20°C', 'Прохладно, без осадков')",
                  "recommendationText": "Советы и рекомендации, адаптированные под погоду и тип места",
                  "estimated_cost": "1000-4000",
                  "map_link": "https://maps.google.com/?cid=13565909931669109964&g_mp=Cidnb29nbGUubWFwcy5wbGFjZXMudjEuUGxhY2VzLlNlYXJjaFRleHQ" // Избегай отправки неработающих ссылок на карты
                }
            ]
          }""";

      final response = await gemini.prompt(
        parts: [Part.text(userPrompt)], 
        model: "gemini-2.5-flash",
      );
      String? jsonString = response?.output;
      if (jsonString == null || jsonString.isEmpty) {
        log('Gemini returned empty output.');
        return null;
      }
      jsonString = jsonString
        .trim()
        .replaceAll('```json', '')
        .replaceAll('```', '');

      final jsonMap = jsonDecode(jsonString);
      return RecommendationModel.fromJson(jsonMap as Map<String, dynamic>);
    } catch (e) {
      log('GEMINI API ERROR: $e');
      return null;
    }
  }

  Future<List<Country>> getCountries() async {
    try {
      final response = await _dioClient.dio.get(
        ApiConfig.countries,
      );
      if (response.statusCode == 200) {
        final List<dynamic> countryJsonList = response.data;
        final List<Country> countries = countryJsonList
          .map((jsonItem) => Country.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

        return countries;
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      throw Exception('Failed to fetch countries: $e');
    }
  }

  Future<List<City>> getCities(int countryId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConfig.getCitiesByid(countryId),
      );
      if (response.statusCode == 200) {
        final List<dynamic> cityJsonList = response.data;
        final List<City> cities = cityJsonList
          .map((jsonItem) => City.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

        return cities;
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      throw Exception('Failed to fetch cities: $e');
    }
  }
}