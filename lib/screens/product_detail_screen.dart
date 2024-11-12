import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../helpers/cart_helper.dart';
import '../widgets/custom_button.dart';
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

  @override
  void initState() {
    super.initState();
    _productFuture = ApiService().fetchProductDetail(widget.productId);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added to cart")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  product.thumbnail,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  product.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Precio: \$${product.price}', style: const TextStyle(fontSize: 16)),
                    Text('Stock: ${product.stock}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: "Cantidad"),
                  keyboardType: TextInputType.number,
                ),
                const Spacer(),
                CustomButton(
                  onPressed: () => _addToCart(product),
                  text: 'Agregar',
                  backgroundColor: Colors.blue,
                  icon: Icons.add_shopping_cart,
                ),
                const SizedBox(height: 16),
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
    );
  }
}
