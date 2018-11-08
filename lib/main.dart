import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled = true;
//  debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepPurple,
          ),
//      home: AuthPage(),
      routes: {
       '/': (BuildContext context) => ProductsPage(_products),
        // '/': (BuildContext context) => AuthPage(),
        '/admin': (BuildContext context) =>
            ProductsAdminPage(_addProduct, _deleteProduct, _products),
      },
      onGenerateRoute: (RouteSettings settings) {
        print('onGenerateRoute: Called');
        final List<String> pathElements = settings.name.split('/'); // exmp. '/admin/1' to '/' 'admin' '/' '1'
        if (pathElements[0] != '') {
          return null;
        }

        // Calls page that displays the product details with '/products/1' (1 is index)
        if (pathElements[1] == 'product') {
          // Gets the index and converts it into a int type instead of String
          final int index = int.parse(pathElements[2]);
          // Actually calls the new page route and passes all data to the page.
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(
                  _products[index]['title'],
                  _products[index]['image'],
                  _products[index]['description'],
                  _products[index]['price'],
                ),
          );
        }

        // If there is not matching page return nothing.
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_products));
      },
    );
  }

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
    print(_products);
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }
}
