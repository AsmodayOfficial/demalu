import 'package:demalu/ui/screens/room/current_room/current_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:demalu/ui/screens/room/room_screen.dart';
import 'package:demalu/ui/screens/budget/budget_screen.dart';
import 'package:demalu/ui/screens/reviews/reviews_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    RoomScreen(),
    //CurrentRoomScreen(),
    ReviewsScreen(),
    BudgetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,

          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: _buildCircleIcon(Icons.home, primaryColor),
              label: 'Комнаты',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.star_outline),
              activeIcon: _buildCircleIcon(Icons.star, primaryColor),
              label: 'Отзывы',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              activeIcon: _buildCircleIcon(
                Icons.account_balance_wallet,
                primaryColor,
              ),
              label: 'Бюджет',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
