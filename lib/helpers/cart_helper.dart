import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'dart:async';

const int MAX_CART_ITEMS = 7;

class CartHelper {
  static Future<void> addToCart(Product product, int quantity) async {
    final prefs = await SharedPreferences.getInstance();

    if (quantity <= 0) {
      throw Exception("Quantity must be greater than zero.");
    }

    if (quantity > product.stock) {
      throw Exception("Quantity exceeds available stock.");
    }

    final cartData = prefs.getString('cart') ?? '[]';
    List<dynamic> cart = jsonDecode(cartData);

    final existingIndex = cart.indexWhere((item) => item['id'] == product.id);

    if (existingIndex != -1) {
      cart[existingIndex]['quantity'] += quantity;
      cart[existingIndex]['total'] = cart[existingIndex]['quantity'] * product.price;
    } else {
      if (cart.length >= MAX_CART_ITEMS) {
        throw Exception("Cart cannot hold more than $MAX_CART_ITEMS unique items.");
      }
      cart.add({
        'id': product.id,
        'name': product.title,
        'price': product.price,
        'quantity': quantity,
        'total': quantity * product.price,
        'date': DateTime.now().toIso8601String(),
        'thumbnail': product.thumbnail,
      });
    }

    prefs.setString('cart', jsonEncode(cart));
  }

  static Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart') ?? '[]';
    List<dynamic> cart = jsonDecode(cartData);

    cart.removeWhere((item) => item['id'] == productId);

    prefs.setString('cart', jsonEncode(cart));
  }

  static Future<void> updateItemQuantity(int productId, int newQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart') ?? '[]';
    List<dynamic> cart = jsonDecode(cartData);

    final index = cart.indexWhere((item) => item['id'] == productId);
    if (index != -1) {
      cart[index]['quantity'] = newQuantity;
      cart[index]['total'] = cart[index]['price'] * newQuantity;
      prefs.setString('cart', jsonEncode(cart));
    }
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cart');
  }

  static Future<List<dynamic>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart') ?? '[]';
    return jsonDecode(cartData);
  }

  static Future<double> getTotalCartValue() async {
    final cart = await getCart();
    return cart.fold<double>(0.0, (total, item) => total + item['total']);
  }
}
