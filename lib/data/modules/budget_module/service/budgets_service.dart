import 'package:demalu/data/modules/budget_module/models/recommendation_model.dart';
import 'package:demalu/data/modules/budget_module/repository/budgets_repository.dart';

class BudgetsService {
  final BudgetsRepository _repository;
  BudgetsService() : _repository = BudgetsRepository();

  Future<RecommendationModel?> getRecommendations(String country, String city, DateTime date, int minPrice, int maxPrice, String? activityType) async {
    return _repository.getRecommendations(country, city, date, minPrice, maxPrice, activityType);
  }
}