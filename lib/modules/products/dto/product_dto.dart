class ProductDto {
  final int id;
  final String title;
  final String description;
  final double price;
  final int stock;

  ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      stock: json['stock'],
    );
  }
}
