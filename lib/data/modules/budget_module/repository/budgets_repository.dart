import 'dart:developer';
import 'package:flutter_gemini/flutter_gemini.dart';

class BudgetsRepository {
  final gemini = Gemini.instance;

  Future<String> getRecommendations(String country, String city, DateTime date) async {
    final response = await gemini.chat(modelName: "gemini-2.5-pro", [
      Content(parts: [Part.text("Write about Adolf Hitler")])
    ]);
    log(response.toString());
    return response.toString();
  }
}