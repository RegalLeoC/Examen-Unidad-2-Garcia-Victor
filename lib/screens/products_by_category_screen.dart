import 'package:flutter/material.dart';

class ProductsByCategoryScreen extends StatelessWidget {
  const ProductsByCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products by Category'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Product 1'),
            onTap: () {
              // Navigate to Product Detail screen with a sample product ID
              Navigator.pushNamed(context, '/productDetail', arguments: 1);
            },
          ),
          ListTile(
            title: const Text('Product 2'),
            onTap: () {
              Navigator.pushNamed(context, '/productDetail', arguments: 2);
            },
          ),
          // Add more products here as needed
        ],
      ),
    );
  }
}
