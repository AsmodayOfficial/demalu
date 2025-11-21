import 'dart:developer';

import 'package:demalu/data/modules/budget_module/models/recommendation_model.dart';
import 'package:demalu/data/modules/budget_module/service/budgets_service.dart';
import 'package:demalu/ui/screens/budget/budgets_screen.dart' show RecommendationsPage;
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
  late final TextEditingController _activityTypeController;

  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _minBudgetController = TextEditingController(text: "0");
    _maxBudgetController = TextEditingController(text: "1000000");
    _activityTypeController = TextEditingController();

    _minBudgetController.addListener(_onMinBudgetChange);
    _maxBudgetController.addListener(_onMaxBudgetChange);
  }

  @override
  void dispose() {
    _minBudgetController.removeListener(_onMinBudgetChange);
    _maxBudgetController.removeListener(_onMaxBudgetChange);
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    _activityTypeController.dispose();
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

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _getRecommendations() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCountry == null || _selectedCity == null) {
      _showErrorSnackbar("Пожалуйста, выберите страну и город.");
      return;
    }
    
    if (_selectedDate == null) {
      _showErrorSnackbar("Пожалуйста, выберите дату путешествия.");
      return;
    }

    final budgetsService = context.read<BudgetsService>();

    if(mounted) setState(() => _isLoading = true );

    final result = await budgetsService.getRecommendations(
      _selectedCountry!.name, 
      _selectedCity!.name, 
      _selectedDate!,
      int.parse(_minBudgetController.text),
      int.parse(_maxBudgetController.text),
      _activityTypeController.text,
    );
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendationsPage(recommendationResult: result),
          ),
        );
      } else {
        log("Ошибка: Рекомендации не получены.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Бюджет'),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: 
          Form(key: _formKey, child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,  
                children: [
                  Text(
                    "Дата путешествия",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'
                          : 'Выберите дату',
                      style: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ),                ]
              ),
              SizedBox(height: 16),
              CountryCityDropdown(onSelectionChanged: _onCityCountrySelected,),
              Row(children: [
                Expanded(
                  child: CustomTextField(
                    label: "Минимальный бюджет",
                    controller: _minBudgetController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Обязательное поле';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Введите число';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextField(
                    label: "Максимальный бюджет",
                    controller: _maxBudgetController,
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Обязательное поле';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Введите число';
                        }
                        return null;
                    },
                  ),
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
              CustomTextField(
                label: "Тип активности",
                hint: "Введите тип активности",
                controller: _activityTypeController
              ),
              SizedBox(height: 32),
              CustomButton(text: "Далее", isLoading: _isLoading, onTap: () => {  _getRecommendations() })
            ],
          ),
        )),
    );
  }
}

