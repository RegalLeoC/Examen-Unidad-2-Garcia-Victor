import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/products_by_category_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/compras_realizadas_screen.dart';
import '../screens/navigation_bar_screen.dart';
import '../screens/search_screen.dart';

class Routes {
  // Route names
  static const String login = '/';
  static const String navigationBar = '/navigationBar';
  static const String categories = '/categories';
  static const String productsByCategory = '/productsByCategory';
  static const String productDetail = '/productDetail';
  static const String cart = '/cart';
  static const String comprasRealizadas = '/comprasRealizadas';
  static const String search = '/search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case navigationBar:
        return MaterialPageRoute(builder: (_) => const NavigationBarScreen());

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

      case cart:
        return MaterialPageRoute(builder: (_) => CartScreen());

      case comprasRealizadas:
        return MaterialPageRoute(builder: (_) => ComprasRealizadasScreen());

      case search:
        return MaterialPageRoute(builder: (_) =>  SearchScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
