// External Imports
import 'package:flutter/material.dart';
// Internal Imports
import '../widgets/drawer.dart';
import './product_list.dart';
import './product_edit.dart';

// To allow navigation between creating a product and editing it
class ProductsAdminPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Returns the Tab Controller to toggle between the two modes
    return DefaultTabController(
      // Sets number of tabs to 2
      length: 2,
      // Create the scaffold of the page
      child: Scaffold(
        // Define the draw widget and pass in the current page which is manage products
        drawer: SideDrawer(PageType.MANAGE_PRODUCTS),
        // Create App bar that will hold the tabs
        appBar: AppBar(
          // Create TabBar widget at the bottom of the app bar
          bottom: TabBar(
            // Create a array of 2 tabs
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
          // The title of the app bar
          title: Text('Product Manager'),
        ),
        // The body of the tabs defined in the TabBarView
        body: TabBarView(
          // List the 2 widgets
          // Each widget will be put in a tab. For example, array item [0] will go with
          // the array from the tabs above at [0]. So [0] with [0], [1] with [1] and so on.
          children: <Widget>[
            // Tab 1
            ProductEditPage(),
            // Tab 2
            ProductList(),
          ],
        ),
      ),
    );
  }
}
