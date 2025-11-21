import 'package:demalu/ui/styles/styles.dart'; // Импорт ваших стилей
import 'package:flutter/material.dart';

class CustomSlidingTabs extends StatefulWidget {
  final Widget firstTabScreen;
  final Widget secondTabScreen;
  final String firstTabTitle;
  final String secondTabTitle;

  const CustomSlidingTabs({
    super.key,
    required this.firstTabScreen,
    required this.secondTabScreen,
    required this.firstTabTitle,
    required this.secondTabTitle,
  });

  @override
  State<CustomSlidingTabs> createState() => _CustomSlidingTabsState();
}

class _CustomSlidingTabsState extends State<CustomSlidingTabs> {
  int _selectedTab = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    setState(() {
      _selectedTab = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Container(
            height: 48, // Высота переключателя
            decoration: BoxDecoration(
              color: Colors.white, // Белый фон контейнера
              borderRadius: BorderRadius.circular(12),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // 1. Анимированная синяя плашка (фон активной кнопки)
                    AnimatedAlign(
                      alignment: _selectedTab == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: constraints.maxWidth / 2,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primary, // Ваш синий цвет
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildTabItem(
                          title: widget.firstTabTitle,
                          index: 0,
                          constraints: constraints,
                        ),
                        _buildTabItem(
                          title: widget.secondTabTitle,
                          index: 1,
                          constraints: constraints,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            children: [
              widget.firstTabScreen,
              widget.secondTabScreen,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({
    required String title,
    required int index,
    required BoxConstraints constraints,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => _switchTab(index),
      child: Container(
        width: constraints.maxWidth / 2,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}