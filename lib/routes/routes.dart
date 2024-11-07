import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/products_by_category_screen.dart';
import '../screens/product_detail_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case '/productsByCategory':
        return MaterialPageRoute(builder: (_) => const ProductsByCategoryScreen());
      case '/productDetail':
        final productId = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: productId));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this screen')),
          ),
        );
    }
  }
}