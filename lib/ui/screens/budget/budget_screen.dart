import 'package:demalu/data/modules/budget_module/models/recommendation_model.dart';
import 'package:demalu/data/modules/budget_module/service/budgets_service.dart';
import 'package:demalu/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool _isLoading = false;
  RangeValues _budgetRange = const RangeValues(0, 1000000);

  late final TextEditingController _minBudgetController;
  late final TextEditingController _maxBudgetController;

  // RecommendationModel? _recommendationResult;

  @override
  void initState() {
    super.initState();
    _minBudgetController = TextEditingController(text: "0");
    _maxBudgetController = TextEditingController(text: "1000000");

    // _fetchRecommendations();
  }

  @override
  void dispose() {
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    super.dispose();
  }


  Future<void> _fetchRecommendations() async {
    final budgetsService = context.read<BudgetsService>();

    if(mounted) setState(() => _isLoading = true );

    final result = await budgetsService.getRecommendations(
      "Kazakhstan", 
      "Shymkent", 
      DateTime.now(),
      0,
      1000000,
      "экстремальный спорт"
    );

    if (mounted) {
      setState(() {
        // _recommendationResult = result;
        _isLoading = false;
      });
    }
  }

  PreferredSizeWidget CustomAppBar({required String title}) {
    return AppBar(title: Text(title, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.blueGrey);
  }

  @override
  Widget build(BuildContext context) {
    if (false) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Бюджет'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Expanded(
                  child: CustomTextField(label: "Минимальный бюджет", controller: _minBudgetController),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextField(label: "Максимальный бюджет", controller: _maxBudgetController),
                ),
              ]),
              RangeSlider(
                values: _budgetRange,
                min: 0,
                max: 1000000,
                divisions: 10000,
                labels: RangeLabels(
                  _budgetRange.start.round().toString(),
                  _budgetRange.end.round().toString(),
                ),
                onChanged: (RangeValues values) => {
                setState(() {
                  _budgetRange = values;
                  _minBudgetController.text = values.start.round().toString();
                  _maxBudgetController.text = values.end.round().toString();
                })
              })
            ],
          ),
        ),
      ),
    );
  }
}