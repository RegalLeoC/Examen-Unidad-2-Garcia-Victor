class Category {
  final String slug;

  Category({required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
  return Category(slug: json['slug']);
}
}
