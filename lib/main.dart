// Import all external packages
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:flutter/rendering.dart';

// Import local packages
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/auth.dart';
import './scoped-models/main.dart';

// The main funtion that is executed on app startup
void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled = true;
//  debugPaintPointersEnabled = true;
  // Starts the class MyApp() which is a Stateful Widget
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Stateful Widget that creates the state _MyAppState()
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Build method that includes the entire app
  @override
  Widget build(BuildContext context) {
    // Creates a variable to hold the MainModel that has all user data
    final MainModel model = MainModel();

    // ScopedModel widget must be first in order for all of app to access data in it
    return ScopedModel<MainModel>(
      model: model,

      // App structure starts
      child: MaterialApp(
        // Some themeing for the app
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepPurple,
        ),

        // Routs give a road map for the app. Use named routes to navigate from one page to another
        routes: {
          // AuthPage is the default page to load because of the special flag '/'
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(model),
          '/admin': (BuildContext context) => ProductsAdminPage(),
        },

        // Use onGenerateRoute to execute code when route is being changed
        onGenerateRoute: (RouteSettings settings) {
          /*  The point of this code is to be able to pass data between pages.
              Not sure if this is needed anymore since we have the Scoped model?
              This might be removed latter on in the course.
          */
          print('onGenerateRoute: Called');
          final List<String> pathElements = settings.name
              .split('/'); // exmp. '/admin/1' to '/' 'admin' '/' '1'
          if (pathElements[0] != '') {
            return null;
          }

          // Calls page that displays the product details with '/products/1' (1 is index)
          if (pathElements[1] == 'product') {
            // Gets the index and converts it into a int type instead of String
            final int index = int.parse(pathElements[2]);
            // Actually calls the new page route and passes all data to the page.
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(index),
            );
          }

          // If there is not matching page return nothing.
          return null;
        },

        // When route is not defined under routes this section of code will execute
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              // Change to the Product Page
              builder: (BuildContext context) => ProductsPage(model));
        },
      ),
    );
  }
}
