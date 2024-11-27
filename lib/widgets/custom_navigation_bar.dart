import 'package:flutter/material.dart';
import '../routes/routes.dart';

class NavigatorBar extends StatelessWidget {
  const NavigatorBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final showNavBar = [
      Routes.categories,
      Routes.productsByCategory,
      Routes.productDetail,
      Routes.search,
      Routes.cart,
      Routes.recentlyViewed,
      Routes.userProfile,
      Routes.comprasRealizadas,
    ].contains(currentRoute);

    if (!showNavBar) return const SizedBox.shrink(); // Do not render if not applicable

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(currentRoute),
      onTap: (index) {
        _navigateTo(context, index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  int _getCurrentIndex(String route) {
    switch (route) {
      case Routes.categories:
        return 0;
      case Routes.search:
        return 1;
      case Routes.cart:
        return 2;
      case Routes.userProfile:
        return 3;
      default:
        return 0;
    }
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, Routes.categories);
        break;
      case 1:
        Navigator.pushNamed(context, Routes.search);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.cart);
        break;
      case 3:
        Navigator.pushNamed(context, Routes.userProfile);
        break;
    }
  }
}
