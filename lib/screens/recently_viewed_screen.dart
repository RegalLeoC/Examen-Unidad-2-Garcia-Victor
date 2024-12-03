import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../helpers/cart_helper.dart';
import '../widgets/custom_navigation_bar.dart';

class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({Key? key}) : super(key: key);

  @override
  State<RecentlyViewedScreen> createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  List<Map<String, dynamic>> _recentlyViewed = [];
  int _selectedIndex = 2; // Assuming Recently Viewed is the 3rd item

  @override
  void initState() {
    super.initState();
    _loadRecentlyViewed();
  }

  Future<void> _loadRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final recentlyViewedString = prefs.getString('recentlyViewed');
    if (recentlyViewedString != null) {
      setState(() {
        _recentlyViewed = List<Map<String, dynamic>>.from(
          Product.decodeRecentlyViewed(recentlyViewedString),
        );
      });
    }
  }

  Future<void> _addToCart(Product product) async {
    try {
      await CartHelper.addToCart(product, 1);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added to cart!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recently Viewed Products')),
      body: _recentlyViewed.isEmpty
          ? const Center(child: Text('No recently viewed products.'))
          : ListView.builder(
              itemCount: _recentlyViewed.length,
              itemBuilder: (context, index) {
                final product = _recentlyViewed[index];
                return ListTile(
                  leading: Image.network(product['thumbnail'], width: 50),
                  title: Text(product['title']),
                  subtitle: Text('Price: \$${product['price']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Views: ${product['views']}'),
                      ElevatedButton(
                        onPressed: () => _addToCart(Product.fromJson(product)),
                        child: const Text('Add to Cart'),
                      ),
                    ],
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
