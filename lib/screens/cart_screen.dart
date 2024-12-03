import 'package:flutter/material.dart';
import '../helpers/cart_helper.dart';
import '../widgets/custom_navigation_bar.dart';
import '../base_auth_screen.dart';

class CartScreen extends BaseAuthScreen {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends BaseAuthScreenState<CartScreen> {
  int _selectedIndex = 1;

  Future<void> _loadCart() async {
    await CartHelper.getCart();
    setState(() {});
  }

  Future<void> _finalizePurchase() async {
    await CartHelper.finalizePurchase();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Compra finalizada con éxito")),
    );
    Navigator.pushNamed(context, '/comprasRealizadas');
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
      appBar: AppBar(
        title: FutureBuilder<double>(
          future: CartHelper.getTotalCartValue(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            return Text('Total: \$${snapshot.data!.toStringAsFixed(2)}');
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: CartHelper.getCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final cart = snapshot.data!;
          if (cart.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    return ListTile(
                      leading: Image.network(item['thumbnail'], width: 50, height: 50),
                      title: Text(item['name']),
                      subtitle: Text(
                          'Cantidad: ${item['quantity']} | Total: \$${item['total'].toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await CartHelper.removeFromCart(item['id']);
                          _loadCart();
                        },
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/productDetail', arguments: item['id']);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _finalizePurchase,
                  child: const Text('Finalizar Compra'),
                ),
              ),
            ],
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
