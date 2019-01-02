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

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
                context,
                '/product/' + productIndex.toString(),
              ),
        ),
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.allProducts[productIndex].isFavoirite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.red,
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
          AddressTag('Union Square, San Francisco'),
          Text(product.userEmail),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
