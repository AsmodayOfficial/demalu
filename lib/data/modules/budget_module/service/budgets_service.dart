import 'package:demalu/data/modules/budget_module/repository/budgets_repository.dart';

class BudgetsService {
  final BudgetsRepository _repository;
  BudgetsService() : _repository = BudgetsRepository();

  Future<String> getRecommendations(String country, String city, DateTime date) async {
    return _repository.getRecommendations(country, city, date);
  }
}