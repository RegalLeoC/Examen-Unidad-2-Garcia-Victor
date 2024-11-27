import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final double rating;
  final double stock;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.rating,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      thumbnail: json['thumbnail'],
      rating: json['rating'].toDouble(),
      stock: json['stock'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'rating': rating,
      'stock': stock,
    };
  }

  /// Decodes a JSON string of recently viewed products into a list of maps.
  static List<Map<String, dynamic>> decodeRecentlyViewed(String jsonString) {
    return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  }

  /// Encodes a list of maps of recently viewed products into a JSON string.
  static String encodeRecentlyViewed(List<Map<String, dynamic>> products) {
    return jsonEncode(products);
  }
}
