import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Category 1'),
            onTap: () {
              // Navigate to Products by Category screen
              Navigator.pushNamed(context, '/productsByCategory');
            },
          ),
          ListTile(
            title: const Text('Category 2'),
            onTap: () {
              Navigator.pushNamed(context, '/productsByCategory');
            },
          ),
          // Add more categories here as needed
        ],
      ),
    );
  }
}
