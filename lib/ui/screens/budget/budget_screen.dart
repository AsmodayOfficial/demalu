import 'package:demalu/data/modules/budget_module/service/budgets_service.dart';
import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  
  @override
  Widget build(BuildContext context) {
    final budgetsService = context.read<BudgetsService>();
    budgetsService.getRecommendations("Kazakhstan", "Shymkent", DateTime.now());
  
    return Scaffold(
      appBar: CustomAppBar(title: 'Бюджет'),
      body: const Center(child: Text('Экран Бюджета')),
    );
  }
}
