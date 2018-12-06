import 'package:flutter/material.dart';
import '../widgets/products/products.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/drawer.dart';
import '../scoped-models/main.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;
  
  ProductsPage(this.model);

  @override
    State<StatefulWidget> createState() {
      return _ProductsPageState();
    }
}

class _ProductsPageState extends State<ProductsPage>{

  @override
  void initState() {
      widget.model.fetchProducts();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(PageType.ALL_PRODUCTS),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: Products(),
    );
  }
}
