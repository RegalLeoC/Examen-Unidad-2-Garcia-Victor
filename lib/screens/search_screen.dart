import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service_search.dart';
import '../routes/routes.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();


}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isLoading = false;

  void _searchProducts() async {
    setState(() => _isLoading = true);
    final results = await ApiService.searchProducts(_searchController.text);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for products...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchProducts,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final product = _searchResults[index];
                    return ListTile(
                      title: Text(product.title),
                      subtitle: Text('\$${product.price}'),
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
  }
}
