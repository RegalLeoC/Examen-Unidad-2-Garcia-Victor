import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_navigation_bar.dart';
import '../routes/routes.dart';
import '../base_auth_screen.dart';

class ProductsByCategoryScreen extends BaseAuthScreen {
  final String category;

  const ProductsByCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _ProductsByCategoryScreenState createState() => _ProductsByCategoryScreenState();
}

class _ProductsByCategoryScreenState extends BaseAuthScreenState<ProductsByCategoryScreen> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/recentlyViewed');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/userProfile');
        break;
    }
  }

  Future<void> _saveRecentlyViewed(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final recentlyViewedString = prefs.getString('recentlyViewed');
    List<Map<String, dynamic>> recentlyViewed = recentlyViewedString != null
        ? Product.decodeRecentlyViewed(recentlyViewedString)
        : [];

    final existingIndex = recentlyViewed.indexWhere((item) => item['id'] == product.id);
    if (existingIndex != -1) {
      recentlyViewed[existingIndex]['views'] = (recentlyViewed[existingIndex]['views'] ?? 0) + 1;
    } else {
      recentlyViewed.add({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'thumbnail': product.thumbnail,
        'views': 1,
      });
    }

    await prefs.setString('recentlyViewed', Product.encodeRecentlyViewed(recentlyViewed));
  }

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
                  onTap: () async {
                    await _saveRecentlyViewed(product);
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
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onDestinationSelected: _onNavItemTapped,
      ),
    );
  }
}
