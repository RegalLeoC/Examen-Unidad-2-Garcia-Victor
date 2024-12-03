import 'package:flutter/material.dart';
import '../screens/search_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/recently_viewed_screen.dart';
import '../screens/user_profile_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    SearchScreen(),
    const CartScreen(),
    const RecentlyViewedScreen(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.visibility),
            label: 'Recently Viewed',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        indicatorColor: theme.colorScheme.primary,
      ),
    );
  }
}
