import 'package:flutter/material.dart';
import '../widgets/products/products.dart';

import '../widgets/drawer.dart';

class ProductsPage extends StatelessWidget {

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
      body: Products(),
    );
  }
}
