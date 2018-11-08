import 'package:flutter/material.dart';

import '../widgets/drawer.dart';
import './product_list.dart';
import './product_edit.dart';

class ProductsAdminPage extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;
  final List<Map<String, dynamic>> products;

  ProductsAdminPage(this.addProduct, this.deleteProduct, this.products);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideDrawer(PageType.MANAGE_PRODUCTS),
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: ('Create Product'),
              ),
              Tab(
                icon: Icon(Icons.list),
                text: ('My Product'),
              ),
            ],
          ),
          title: Text('Product Manager'),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductEditPage(addProduct: addProduct),
            ProductList(products),
          ],
        ),
      ),
    );
  }
}
