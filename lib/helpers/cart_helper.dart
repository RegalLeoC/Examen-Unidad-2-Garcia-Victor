import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartHelper {
  static const String cartKey = 'cart';

  static Future<void> addToCart(Product product, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    final existingProductIndex = cart.indexWhere((item) => item['id'] == product.id);
    Map<String, dynamic> existingProduct = existingProductIndex != -1
        ? cart[existingProductIndex]
        : {};

    if (existingProduct.isNotEmpty) {

      int currentQuantity = existingProduct['quantity'] ?? 0;
      int newQuantity = currentQuantity + quantity;

      if (newQuantity > product.stock) {
        throw Exception("Not enough stock. You can only add up to ${product.stock - currentQuantity} more.");
      }

      cart[existingProductIndex]['quantity'] = newQuantity;
      cart[existingProductIndex]['total'] = newQuantity * product.price;
    } else {
      
      if (cart.length >= 7) {
        throw Exception("You can only add up to 7 unique products.");
      }

      if (quantity > product.stock) {
        throw Exception("Not enough stock. Maximum available: ${product.stock}");
      }

      cart.add({
        'id': product.id,
        'name': product.title,
        'quantity': quantity,
        'price': product.price,
        'total': quantity * product.price,
        'thumbnail': product.thumbnail,
      });
    }

    await prefs.setString(cartKey, jsonEncode(cart));
  }

  static Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString(cartKey);
    if (cartString != null) {
      try {
        return List<Map<String, dynamic>>.from(jsonDecode(cartString));
      } catch (e) {
        print("Error decoding cart JSON: $e");
      }
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


   // Check if the product has reached its stock limit in the cart
  static Future<bool> isProductAtStockLimit(Product product) async {
  final cart = await getCart();
  final existingProduct = cart.firstWhere((item) => item['id'] == product.id, orElse: () => {});
  
  int currentQuantity = existingProduct['quantity'] ?? 0;
  return currentQuantity >= product.stock;
  }

  // Check if the cart has reached the maximum unique items limit
  static Future<bool> isCartAtLimit() async {
    final cart = await getCart();
    return cart.length >= 7;
  }

  // Check if the product is considered "agotado" (out of stock in cart or cart limit reached)
  static Future<bool> isProductOutOfStock(Product product) async {
    return await isProductAtStockLimit(product) || await isCartAtLimit();
  }
}
