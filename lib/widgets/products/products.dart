import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/products.dart';

class Products extends StatelessWidget {
  // Creates the list of products displayed on the home page
  Widget _buildProductList(List<Product> product) {
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
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}
