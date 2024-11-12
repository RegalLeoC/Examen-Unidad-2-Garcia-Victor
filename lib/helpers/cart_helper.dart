import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartHelper {
  static const String cartKey = 'cart';

  static Future<void> addToCart(Product product, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    final existingProduct = cart.firstWhere(
      (item) => item['id'] == product.id,
      orElse: () => {},
    );

    if (existingProduct.isNotEmpty) {
      existingProduct['quantity'] += quantity;
      existingProduct['total'] = existingProduct['quantity'] * product.price;
    } else {
      if (cart.length < 7) {
        cart.add({
          'id': product.id,
          'name': product.title,
          'quantity': quantity,
          'price': product.price,
          'total': quantity * product.price,
          'thumbnail': product.thumbnail,
        });
      } else {
        throw Exception("You can only add up to 7 unique products.");
      }
    }

    await prefs.setString(cartKey, jsonEncode(cart));
  }

  static Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString(cartKey);
    if (cartString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(cartString));
    }
    return [];
  }

  static Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();
    cart.removeWhere((item) => item['id'] == productId);
    await prefs.setString(cartKey, jsonEncode(cart));
  }

  static Future<double> getTotalCartValue() async {
    final cart = await getCart();
    return cart.fold<double>(0.0, (total, item) => total + (item['total'] as double));
  }
}
