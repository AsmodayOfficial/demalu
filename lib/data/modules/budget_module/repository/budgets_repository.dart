import 'dart:convert';
import 'dart:developer';
import 'package:demalu/data/modules/budget_module/models/recommendation_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class BudgetsRepository {
  final gemini = Gemini.instance;

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
                  "recommendationText": "Советы и рекомендации, адаптированные под погоду и тип места"
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
}