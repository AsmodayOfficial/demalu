import 'dart:developer';

import 'package:demalu/data/modules/budget_module/models/recommendation_model.dart';
import 'package:demalu/data/modules/budget_module/service/budgets_service.dart';
import 'package:demalu/ui/widgets/country_city_dropdown.dart';
import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:demalu/ui/widgets/custom_button.dart';
import 'package:demalu/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double kMinBudget = 0.0;
const double kMaxBudget = 1000000.0;

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool _isLoading = false;
  RangeValues _budgetRange = const RangeValues(kMinBudget, kMaxBudget);
  
  City? _selectedCity;
  Country? _selectedCountry;
  DateTime? _selectedDate;

  late final TextEditingController _minBudgetController;
  late final TextEditingController _maxBudgetController;

  // RecommendationModel? _recommendationResult;

  @override
  void initState() {
    super.initState();
    _minBudgetController = TextEditingController(text: "0");
    _maxBudgetController = TextEditingController(text: "1000000");

    _minBudgetController.addListener(_onMinBudgetChange);
    _maxBudgetController.addListener(_onMaxBudgetChange);
    // _fetchRecommendations();
  }

  @override
  void dispose() {
    _minBudgetController.removeListener(_onMinBudgetChange);
    _maxBudgetController.removeListener(_onMaxBudgetChange);
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    super.dispose();
  }

  void _onCityCountrySelected(Country? country, City? city) {
    setState(() {
      _selectedCountry = country;
      _selectedCity = city;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 1, 31),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _onMinBudgetChange() {
    final text = _minBudgetController.text;
    final value = double.tryParse(text);

    if (value != null) {
      final newStart = value.clamp(0.0, _budgetRange.end).toDouble();
      if (_budgetRange.start != newStart) {
        setState(() {
          _budgetRange = RangeValues(newStart, _budgetRange.end);
        });
      }
    }
  }

  void _onMaxBudgetChange() {
    final text = _maxBudgetController.text;
    final value = double.tryParse(text);

    if (value != null) {
      final newEnd = value.clamp(_budgetRange.start, kMaxBudget).toDouble();
      if (_budgetRange.end != newEnd) {
        setState(() {
          _budgetRange = RangeValues(_budgetRange.start, newEnd);
        });
      }
    }
  }

  Future<void> _fetchRecommendations() async {
    final budgetsService = context.read<BudgetsService>();

    if(mounted) setState(() => _isLoading = true );

    final result = await budgetsService.getRecommendations(
      _selectedCountry!.name, 
      _selectedCity!.name, 
      _selectedDate!,
      int.parse(_minBudgetController.text),
      int.parse(_maxBudgetController.text),
      "экстремальный спорт"
    );

    if (mounted) {
      setState(() {
        // _recommendationResult = result;
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Бюджет'),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Дата не выбрана',
                ),
                OutlinedButton(onPressed: _selectDate, child: const Text('Выбрать дату')),
              ]),
              CountryCityDropdown(onSelectionChanged: _onCityCountrySelected,),
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
                min: kMinBudget,
                max: kMaxBudget,
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
              }),
              CustomButton(text: "Далее", isLoading: _isLoading, onTap: () => { })
            ],
          ),
        ),
    );
  }
}

