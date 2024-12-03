import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: widget.currentIndex,
      onDestinationSelected: widget.onDestinationSelected,
      destinations: const [
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
          selectedIcon: Icon(Icons.history),
          icon: Icon(Icons.history_outlined),
          label: 'Recently Viewed',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outline),
          label: 'User Profile',
        ),
      ],
    );
  }
}
