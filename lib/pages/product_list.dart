// Shows a list of products and allows you to edit or remove them

// External Imports
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// Internal Imports
import './product_edit.dart';
import '../scoped-models/main.dart';

// A Page under Product Admin that allows us to edit products
class ProductList extends StatelessWidget {

  // A widget that is the edit button for our product
  // Needs the index of the product and the model
  Widget _buildEditButton(
      BuildContext context, int index, MainModel model) {
    // Our Icon button widget
    return IconButton(
      // Edit icon from the Icons class
      icon: Icon(Icons.edit),
      // When pressed on
      onPressed: () {
        // Select the product from the index given
        model.selectProduct(index);
        // Navigate to the product edit page without a named route
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            },
          ),
        // When returned back to this page, clear the selected product
        ).then((_) {
          model.selectProduct(null);
        });
      },
    );
  }

  // Build the page
  @override
  Widget build(BuildContext context) {
    // Need access to our model
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        // Return a list view so that the list is scrollable
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            // A widget that allows us to swipe products away and remove them
            return Dismissible(
              // Not sure what this is.....
              key: Key(model.allProducts[index].title),
              // When a product is dissmissed
              onDismissed: (DismissDirection direction) {
                // If swipped from right to left, run this
                if (direction == DismissDirection.endToStart) {
                  // Select product
                  model.selectProduct(index);
                  // Remove the product
                  model.deleteProduct();
                }
              },
              // Delete Backround Icon
              background: Container(
                // Color of the background
                color: Colors.red,
                // Child where Icon will be
                child: Row(
                  // Set alignment to the right
                  mainAxisAlignment: MainAxisAlignment.end,
                  // List the icon in a container with padding
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              // The view where are the products can be seen
              child: Column(
                children: <Widget>[
                  // Use a list tile to display the product
                  ListTile(
                    // A circle image that will be the product
                    leading: CircleAvatar(
                      // Product image
                      backgroundImage: NetworkImage(model.allProducts[index].image),
                    ),
                    // The Title of the product
                    title: Text(model.allProducts[index].title),
                    // The price of the product
                    subtitle:
                        Text('\$${model.allProducts[index].price.toString()}'),
                    // Edit button widget as defined above ^^^
                    trailing: _buildEditButton(context, index, model),
                  ),
                  // A divider to put a line between each product
                  Divider(),
                ],
              ),
            );
          },
          // Tells how many items are in the list view.
          // Get a count of our curent products
          itemCount: model.allProducts.length,
        );
      },
    );
  }
}
