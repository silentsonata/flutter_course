import 'package:flutter/material.dart';

enum PageType { ALL_PRODUCTS, MANAGE_PRODUCTS }

class SideDrawer extends StatelessWidget {
  final PageType type;

  SideDrawer(this.type);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: _pageSelector(context),
      ),
    );
  }

  List<Widget> _pageSelector(BuildContext context) {
    List selectorWidgetArray = <Widget>[];

    selectorWidgetArray.add(
      AppBar(
        automaticallyImplyLeading: false,
        title: Text('Choose'),
      ),
    );

    if (type != PageType.ALL_PRODUCTS) {
      selectorWidgetArray.add(
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('All Products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      );
    }

    if (type != PageType.MANAGE_PRODUCTS) {
      selectorWidgetArray.add(
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/admin');
          },
        ),
      );
    }

    return selectorWidgetArray;
  }
}
