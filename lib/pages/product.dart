// External Imports
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
// Internal Imports
import '../widgets/ui_elements/title_default.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

// A description page that shows all the details of a selected product
class ProductPage extends StatelessWidget {
  // Product index of the selected product
  final int productIndex;
  // Ask for the index
  ProductPage(this.productIndex);

  // A widget that will build the title row
  Widget _buildTitleRow(String title, double price) {
    // Create a row
    return Row(
      // Creates space between each child
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // Expands across the whole horizontal axis
      mainAxisSize: MainAxisSize.max,
      // List children for the row
      children: <Widget>[
        // Row that will hold the title and price
        Row(
          children: <Widget>[
            // Title container that has padding
            Container(
              padding: EdgeInsets.all(10.0),
              child: TitleDefault(title),
            ),
            // Price container that includes a left boarder and padded text
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 2.0),
                ),
              ),
              child: Text(
                // A string with a flag to allow functions. Could we not also just call the funciton without
                // surrounding it in a string? The Text widget may not allow that.
                '\$${price.toString()}',
                // Sets the style of the text
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ],
        ),
        // LOCATION
        // Container that holds the location text
        Container(
          margin: EdgeInsets.all(10.0),
          child: Text(
            'Union Square, San Fancisco',
            style: TextStyle(fontFamily: 'Oswald'),
          ),
        ),
      ],
    );
  }

  // Build the layout
  @override
  Widget build(BuildContext context) {
    // WillPopScope: a widget that adds a back button and allows us to return to the
    // previous page.
    return WillPopScope(
      // When pressed 
      onWillPop: () {
        print('Back button pressed.');
        // Will pop the current page with a return of false (which we are not using the return at this point...I think)
        Navigator.pop(context, false);
        // Returns a future value of false....again not sure if we are using this
        return Future.value(false);
      },
      // The child is where the page content will be drawn
      // We need access to our model so use the ScopedModelDescendant
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          // Save the selected product to a variable so we can use it
          final Product product = model.allProducts[productIndex];
          // Create the scaffold
          return Scaffold(
            // App bar that has the product title in it
            appBar: AppBar(
              title: Text(product.title),
            ),
            // Column that will hold the page content
            body: Column(
              // Center all items
              crossAxisAlignment: CrossAxisAlignment.center,
              // Child of widgets in array form
              children: <Widget>[
                // Image of the product
                // TODO: Not Working
                Image.asset(product.image),
                // Build the title row that includes the title, price, and static location
                _buildTitleRow(product.title, product.price),
                // A description section that shows the description of the product
                Container(
                  // Add a margin to space widget
                  margin: EdgeInsets.all(10.0),
                  // Text widget that shows the description
                  child: Text(
                    product.description,
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
