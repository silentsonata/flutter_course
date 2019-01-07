// External Imports
import 'package:flutter/material.dart';

// Create a type of variable with an enum
enum PageType { ALL_PRODUCTS, MANAGE_PRODUCTS }


class SideDrawer extends StatelessWidget {
  // Create a variable with type PageType
  final PageType type;
  // Accept this type of variable at build
  SideDrawer(this.type);

  @override
  Widget build(BuildContext context) {
    // Return a drawer widget
    return Drawer(
      // Create a column pointed at _pageSelector
      child: Column(
        children: _pageSelector(context),
      ),
    );
  }

  // Create a list of widgets that will contain the menu items
  List<Widget> _pageSelector(BuildContext context) {
    // The array where the widgets will be held
    List selectorWidgetArray = <Widget>[];

    // Add the app bar that will say choose
    selectorWidgetArray.add(
      AppBar(
        automaticallyImplyLeading: false,
        title: Text('Choose'),
      ),
    );

    // Detect what pages to show
    // What ever type is passed in will not show, Will act as current page
    // If it is not all products create a list tile that will navigate to products
    if (type != PageType.ALL_PRODUCTS) {
      selectorWidgetArray.add(
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('All Products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/products');
          },
        ),
      );
    }

    // If it is not manage products create a list tile that will navigate to admin
    // Navigates to the Admin page
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

    // Once the widget list is built and has run through all the checks above, return it
    return selectorWidgetArray;
  }
}