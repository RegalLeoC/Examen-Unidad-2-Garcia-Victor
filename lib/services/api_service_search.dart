import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/products';

  static Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['products'];
      return List<Product>.from(data.map((item) => Product.fromJson(item)));
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
