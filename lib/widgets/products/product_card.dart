// External imports
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// Local imports
import 'address_tag.dart';
import '../ui_elements/price_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  // Pass through a product and it's index
  final Product product;
  final int productIndex;
  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
      // Add a margin on top to separate from image
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        // Centers everything in the row
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Use the default title widget to create the title text
          TitleDefault(product.title),
          // Spacing between the objects
          SizedBox(
            width: 8.0,
          ),
          // Use the default price tag to show text (defined in ui_elements)
          PriceTag(product.price.toString()),
        ],
      ),
    );
  }

  // Widget that builds all the action buttons
  Widget _buildActionButtons(BuildContext context) {
    // Create a button bar that lets us put multiple buttons in a row
    return ButtonBar(
      // Set the alignment to center
      alignment: MainAxisAlignment.center,
      // List the buttons as a array in children
      children: <Widget>[
        // INFO BUTTON
        // Icon button that will open the product details
        IconButton(
          // Sets the icon with an icon from the Icon class
          icon: Icon(Icons.info),
          // Sets the color of the icon to the accent theme color
          color: Theme.of(context).accentColor,
          // The action that happens when tapped
          onPressed: () => Navigator.pushNamed<bool>(
                context,
                '/product/' + productIndex.toString(),
              ),
        ),
        // FAVORITE BUTTON
        // Icon button that will toggle said product as a favorite
        // Will need to store favorite preference in the model so we need access to it
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            // Icon button
            return IconButton(
              // Checks to see if product is favorite. If so change the icon.
              icon: Icon(model.allProducts[productIndex].isFavoirite
                  ? Icons.favorite
                  : Icons.favorite_border),
              // Set the icon color
              color: Colors.red,
              // When pressed, select the product and toggle the favorite status
              onPressed: () {
                model.selectProduct(productIndex);
                model.toggleProductFavoriteStatues();
              },
            );
          },
        ),
      ],
    );
  }

  // Builds the card
  @override
  Widget build(BuildContext context) {
    // Returns a card that shows the product
    return Card(
      child: Column(
        children: <Widget>[
          // Load an image from the network (url) stored in the product
          Image.network(product.image),
          // Create the text section with the title and price
          _buildTitlePriceRow(),
          // Static address tag - Will be updated
          AddressTag('Union Square, San Francisco'),
          // User's email (Not sure why this is would be helpful)
          Text(product.userEmail),
          // Builds the action buttons widget from above
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
