import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the purchase date
import '../helpers/cart_helper.dart'; // To retrieve stored purchases


class ComprasRealizadasScreen extends StatelessWidget {
  const ComprasRealizadasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compras Realizadas')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: CartHelper.getPurchases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final purchases = snapshot.data!;
          if (purchases.isEmpty) {
            return const Center(child: Text('No purchases made'));
          }

          return ListView.builder(
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              final purchase = purchases[index];
              final date = DateTime.parse(purchase['date']);
              final total = purchase['total'].toStringAsFixed(2);
              final totalItems = purchase['totalItems'];

              return ListTile(
                title: Text('Date: ${date.toLocal()}'),
                subtitle: Text('Total Items: $totalItems | Total: \$ $total'),
              );
            },
          );
        },
      ),
    );
  }
}
