import 'package:demalu/data/modules/budget_module/models/recommendation_model.dart';
import 'package:demalu/data/modules/budget_module/service/budgets_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryCityDropdown extends StatefulWidget {
  final void Function(Country? country, City? city) onSelectionChanged;
  const CountryCityDropdown({super.key, required this.onSelectionChanged});

  @override
  State<CountryCityDropdown> createState() => _CountryCityDropdownState();
}

class _CountryCityDropdownState extends State<CountryCityDropdown> {
  City? _selectedCity;
  Country? _selectedCountry;
  List<Country> _countries = [];
  List<City> _cities = [];


  void _getCountries() async {
    final budgetsService = context.read<BudgetsService>();
    final countries = await budgetsService.getCountries();

    if(mounted) {
      setState(() {
        _countries = countries;
      });
    }
  }

  void _getCities(countryId) async {
    final budgetsService = context.read<BudgetsService>();
    final cities = await budgetsService.getCities(countryId);

    if(mounted) {
      setState(() {
        _cities = cities;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getCountries();
  }

@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Country Dropdown ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity, // Forces full width
            child: DropdownButtonHideUnderline( // Optional: Hides the default underline
              child: DropdownButton<Country>(
                isExpanded: true, // Crucial for using the full width inside the SizedBox
                value: _selectedCountry,
                hint: const Text('Выберите страну'),
                items: _countries.map((Country country) {
                  return DropdownMenuItem<Country>(
                    value: country,
                    child: Text(country.name),
                  );
                }).toList(),
                onChanged: (Country? newValue) {
                  if(newValue == _selectedCountry) return;
                  setState(() {
                    _selectedCountry = newValue;
                    _selectedCity = null;
                    _cities = [];
                  });
                  if (newValue != null) {
                    _getCities(newValue.id);
                  } else {
                    setState(() {
                      _cities = [];
                    });
                  }
                  widget.onSelectionChanged(_selectedCountry, _selectedCity);
                },
              ),
            ),
          ),
        ),

        // --- City Dropdown ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity, // Forces full width
            child: DropdownButtonHideUnderline( // Optional: Hides the default underline
              child: DropdownButton<City>(
                isExpanded: true, // Crucial for using the full width inside the SizedBox
                value: _selectedCity,
                hint: const Text('Выберите город'),
                // Disable if no country is selected OR if the cities list is empty
                onChanged: (_selectedCountry == null || _cities.isEmpty)
                    ? null
                    : (City? newValue) {
                        setState(() {
                          _selectedCity = newValue;
                        });
                        widget.onSelectionChanged(_selectedCountry, _selectedCity);
                      },
                items: _cities.map((City city) {
                  return DropdownMenuItem<City>(
                    value: city,
                    child: Text(city.name),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
