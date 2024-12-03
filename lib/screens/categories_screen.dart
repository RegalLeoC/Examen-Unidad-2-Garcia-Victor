import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/custom_navigation_bar.dart';
import '../base_auth_screen.dart';

class CategoriesScreen extends BaseAuthScreen {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends BaseAuthScreenState<CategoriesScreen> {
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
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onDestinationSelected: _onNavItemTapped,
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final bool isBlueTheme;
  final VoidCallback onTap;

  const CategoryTile({
    Key? key,
    required this.categoryName,
    required this.isBlueTheme,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isBlueTheme ? Icons.shopping_bag : Icons.fastfood,
        color: isBlueTheme ? Colors.blue : Colors.red,
      ),
      title: Text(
        categoryName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isBlueTheme ? Colors.blue : Colors.red,
      ),
      onTap: onTap,
    );
  }
}
