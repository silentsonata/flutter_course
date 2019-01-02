// External imports
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// Local imports
import 'product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class Products extends StatelessWidget {
  // Creates the list of products displayed on the home page
  Widget _buildProductList(List<Product> product) {
    // Creates an empty productCards widget
    Widget productCards;

    // 
    if (product.length > 0) {
      // Create a scrollable List View
      productCards = ListView.builder(
        // Will create a ProductCard widget for however many times defined in itemCount
        itemBuilder: (BuildContext context, int index) =>
            // Get the current index that the listview is on
            ProductCard(product[index], index),
        itemCount: product.length,
      );
    } else {
      // If there is no products just send back an empty container
      productCards = Container();
    }

    // Return the result
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    // Create a decendant to access the values in the model.
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        // Create a product list with only the displayed products
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}
