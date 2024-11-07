import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Product Name', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8.0),
            Text('\$123.45', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            Text('Product Description', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4.0),
                Text('4.5', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 4.0),
                Text('(120 Reviews)', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle Buy button press
              },
              child: const Text('Buy Now'),
            ),
          ],
        ),
      ),
    );
  }
}
