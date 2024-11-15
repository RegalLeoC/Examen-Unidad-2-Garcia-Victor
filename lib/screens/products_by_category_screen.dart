import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';
import '../routes/routes.dart';
import '../base_auth_screen.dart';

class ProductsByCategoryScreen extends BaseAuthScreen {
  final String category;

  const ProductsByCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _ProductsByCategoryScreenState createState() => _ProductsByCategoryScreenState();
}

class _ProductsByCategoryScreenState extends BaseAuthScreenState<ProductsByCategoryScreen> {
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Products in ${widget.category}'),
      body: FutureBuilder<List<Product>>(
        future: ApiService().fetchProductsByCategory(widget.category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.productDetail,
                      arguments: product.id,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
