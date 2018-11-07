import 'package:flutter/material.dart';

import 'product_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> product;

  // Constructor
  Products(this.product) {
    print('[Products Widget] Constructor');
  }

  // Creates the list of products displayed on the home page
  Widget _buildProductList() {
    Widget productCards;
    if (product.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(product[index], index),
        itemCount: product.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return _buildProductList();
  }
}
