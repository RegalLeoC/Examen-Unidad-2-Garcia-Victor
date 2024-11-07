import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductsByCategoryScreen extends StatelessWidget {
  final String category;

  const ProductsByCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products in $category')),
      body: FutureBuilder<List<Product>>(
        future: ApiService().fetchProductsByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(product.thumbnail, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(product.title),
                subtitle: Text('\$${product.price}'),
                onTap: () {
                  Navigator.pushNamed(context, '/productDetail', arguments: product.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
