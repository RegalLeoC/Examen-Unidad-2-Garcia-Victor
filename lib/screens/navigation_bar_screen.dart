import 'package:examen_u2_garcia_victor/screens/search_screen.dart';
import 'package:examen_u2_garcia_victor/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import '../screens/categories_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/login_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CategoriesScreen(), 
    SearchScreen(),            
    CartScreen(),             
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.shopping_cart),
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
