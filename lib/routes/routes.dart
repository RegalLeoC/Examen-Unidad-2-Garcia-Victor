import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/products_by_category_screen.dart';
import '../screens/product_detail_screen.dart';

class Routes {
  static const String login = '/';
  static const String categories = '/categories';
  static const String productsByCategory = '/productsByCategory';
  static const String productDetail = '/productDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());

      case productsByCategory:
        // Expecting a String argument for category name
        final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductsByCategoryScreen(category: category),
        );

      case productDetail:
        // Expecting an int argument for product ID
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
