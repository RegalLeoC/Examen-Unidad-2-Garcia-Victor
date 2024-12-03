import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../helpers/cart_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_navigation_bar.dart';
import '../base_auth_screen.dart';

class ProductDetailScreen extends BaseAuthScreen {
  final int productId;

  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends BaseAuthScreenState<ProductDetailScreen> {
  final TextEditingController _quantityController = TextEditingController();
  late Future<Product> _productFuture;
  bool showAddButton = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _productFuture = ApiService().fetchProductDetail(widget.productId);
    _checkButtonVisibility();
  }

  Future<void> _checkButtonVisibility() async {
    final product = await _productFuture;
    bool atStockLimit = await CartHelper.isProductAtStockLimit(product);
    bool atCartLimit = await CartHelper.isCartAtLimit();

    setState(() {
      showAddButton = !(atStockLimit || atCartLimit);
    });
  }

  Future<void> _addToCart(Product product) async {
    try {
      if (_quantityController.text.isEmpty || int.tryParse(_quantityController.text) == null) {
        throw Exception("Please enter a valid quantity.");
      }
      int quantity = int.parse(_quantityController.text);
      if (quantity <= 0) {
        throw Exception("Quantity must be greater than zero.");
      }

      await CartHelper.addToCart(product, quantity);
      _checkButtonVisibility();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added to cart")),
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
      appBar: AppBar(title: const Text('Detalle de producto')),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final product = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Image.network(
                  product.thumbnail,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Text(
                  product.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Precio: \$${product.price} | Stock: ${product.stock}'),
                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: "Cantidad"),
                  keyboardType: TextInputType.number,
                ),
                if (showAddButton)
                  CustomButton(
                    onPressed: () => _addToCart(product),
                    text: 'Agregar',
                    backgroundColor: Colors.blue,
                    icon: Icons.add_shopping_cart,
                  ),
                CustomButton(
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  text: 'Ir al carrito',
                  backgroundColor: Colors.green,
                  icon: Icons.shopping_cart,
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
