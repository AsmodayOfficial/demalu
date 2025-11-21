import 'dart:developer';

import 'package:demalu/data/modules/budget_module/models/recommendation_model.dart';
import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationsPage extends StatelessWidget {
  final RecommendationModel recommendationResult;

  const RecommendationsPage({
    super.key,
    required this.recommendationResult,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Рекомендации для ${recommendationResult.city}"),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: recommendationResult.recommendations.length,
        itemBuilder: (context, index) {
          final item = recommendationResult.recommendations[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Тип: ${item.type}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text('Погода: ${item.weather}'),
                  const SizedBox(height: 8),
                  Text(item.recommendationText),
                  if (item.map_link != null) ...[
                    const SizedBox(height: 8),
                    // Кнопка для открытия карты (опционально)
                    TextButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(item.map_link);
                        if (!await launchUrl(url)) {
                          throw Exception('Не удалось открыть $url');
                        }
                        log('Карта: ${item.map_link}');
                      },
                      child: const Text('Показать на карте (Google Maps)'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}