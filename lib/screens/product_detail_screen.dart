import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: FutureBuilder<Product>(
        future: ApiService().fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(product.thumbnail, width: double.infinity, height: 200, fit: BoxFit.cover),
                const SizedBox(height: 16.0),
                Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
                Text('\$${product.price}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16.0),
                Text(product.description),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text('${product.rating}', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Buy button functionality
                  },
                  child: const Text('Buy Now'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
