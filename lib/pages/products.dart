import 'package:flutter/material.dart';
import '../widgets/products/products.dart';

import '../widgets/drawer.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductsPage(this.products);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(PageType.ALL_PRODUCTS),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
      body: Products(products),
    );
  }
}
