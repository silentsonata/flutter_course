// External Imports
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// Internal Imports
import '../widgets/products/products.dart';
import '../widgets/drawer.dart';
import '../scoped-models/main.dart';

// List of each products cards
class ProductsPage extends StatefulWidget {
  // Store the model passed in
  final MainModel model;
  ProductsPage(this.model);

  // Create State
  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  // This runs when the state is first created before build is executed
  @override
  void initState() {
    // Gets everything from model???
    widget.model.fetchProducts();
    super.initState();
  }

  // A Widget that will hide content until it is downloaded
  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        // Set up a widget to hold the content
        Widget content = Center(child: Text("No Products Found"));
        // If there is content and its done loading then show the products
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = Products();

          // If the content is loading show a progress indicator
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }

        // Return the result of what content to show
        return content;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Creates our Scaffold
    return Scaffold(
      // Assign the draw and pass in the current page type (So not shown)
      drawer: SideDrawer(PageType.ALL_PRODUCTS),
      // Create app bar
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          // Favorites Button
          // Wrap in decendant because we need to fetch favorites
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                // If true then the icon will be filled in, if false there will be a border icon
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  // When pressed will toggle only favorites or all products
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      // Body section that will list the products
      // Call build products widget to either show spinner, no product, or the products
      body: _buildProductsList(),
    );
  }
}
