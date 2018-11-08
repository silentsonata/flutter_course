import 'package:flutter/material.dart';

import './product_edit.dart';

class ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductList(this.products);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.ac_unit),
          title: Text(products[index]['title']),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ProductEditPage(products: products[index]);
                  },
                ),
              );
            },
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
