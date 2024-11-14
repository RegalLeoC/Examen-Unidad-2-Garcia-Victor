import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/products_by_category_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/compras_realizadas_screen.dart';

class Routes {
  static const String login = '/';
  static const String categories = '/categories';
  static const String productsByCategory = '/productsByCategory';
  static const String productDetail = '/productDetail';
  static const String cart = '/cart';
  static const String comprasRealizadas = '/comprasRealizadas';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case cart:
        return MaterialPageRoute(builder: (_) => CartScreen());

      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());

      case productsByCategory:
        final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductsByCategoryScreen(category: category),
        );

      case productDetail:
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );

      case comprasRealizadas:
        return MaterialPageRoute(builder: (_) => ComprasRealizadasScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
