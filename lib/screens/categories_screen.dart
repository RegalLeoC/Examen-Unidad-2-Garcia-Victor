import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: FutureBuilder<List<Category>>(
        future: ApiService().fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? [];
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isEvenIndex = index % 2 == 0; 
              return CategoryTile(
                categoryName: category.slug,
                isBlueTheme: isEvenIndex,
                onTap: () {
                  Navigator.pushNamed(context, '/productsByCategory', arguments: category.slug);
                },
              );
            },
          );
        },
      ),
    );
  }
}


class CategoryTile extends StatelessWidget {
  final String categoryName;
  final bool isBlueTheme;
  final VoidCallback onTap;

  const CategoryTile({Key? key, required this.categoryName, required this.isBlueTheme, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isBlueTheme ? Icons.shopping_bag : Icons.fastfood, // Alternate icon
        color: isBlueTheme ? Colors.blue : Colors.red, // Alternate color
      ),
      title: Text(
        categoryName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isBlueTheme ? Colors.blue : Colors.red, // Alternate arrow color
      ),
      onTap: onTap,
    );
  }
}
