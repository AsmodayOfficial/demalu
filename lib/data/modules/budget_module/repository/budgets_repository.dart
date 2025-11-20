import 'dart:developer';
import 'package:flutter_gemini/flutter_gemini.dart';

class BudgetsRepository {
  final gemini = Gemini.instance;

  Future<String> getRecommendations(String country, String city, DateTime date) async {
    try {
      final userPrompt = 
          "Provide a concise travel recommendation for a trip to $city, $country on ${date.toIso8601String().substring(0, 10)}. "
          "Focus on budget travel tips.";

      final response = await gemini.prompt(
        parts: [Part.text(userPrompt)], 
        model: "gemini-2.5-flash" 
      );
      
      return response?.output ?? "{}";
    } catch (e) {
      log('GEMINI API ERROR: $e');
      return "Error: $e";
    }
  }
}