// External Imports
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// Internal Imports
import '../models/product.dart';
import '../scoped-models/main.dart';

// Creates statful widget
class ProductEditPage extends StatefulWidget {
  @override
  State createState() {
    return _ProductEditPageState();
  }
}

// Create the state
class _ProductEditPageState extends State<ProductEditPage> {
  // Data that will be pulled from the form and stored into this map
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg',
  };
  // A unique key that is required for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // A widget that builds the title text field
  Widget _buildTitleTextField(Product product) {
    // Return the TextFormField
    return TextFormField(
      // Add label text by using decoration
      decoration: InputDecoration(labelText: 'Product Title'),
      // Sets the initial value since this will be used for both creating and editing.
      // Can not put 'null' in as the initial value so make a blank string
      // If the product is not null then put in the title
      initialValue: product == null ? '' : product.title,
      // If nothing is returned no error has been found and form continues
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long';
        }
      },
      // This executes when onSaved is called when the submit button is pressed
      onSaved: (String value) {
        // Assigns the title to the curent value in the field
        _formData['title'] = value;
      },
    );
  }

  // A Description Text Field Widget
  Widget _buildDescriptionTextField(Product product) {
    // Returns the widget
    return TextFormField(
      // Sets the max number of lines
      maxLines: 4,
      // Adds the label via decoration
      decoration: InputDecoration(labelText: 'Product Description'),
      // Same thing as above to make sure null is not assigned
      initialValue: product == null ? '' : product.description,
      // Validates the input
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should be 10+ characters long';
        }
      },
      // Runs on submit
      onSaved: (String value) {
        // Assigns the value
        _formData['description'] = value;
      },
    );
  }

  // The price field widget
  Widget _buildPriceTextField(Product product) {
    // Returns the widget
    return TextFormField(
      // Sets the keyboard type to number
      keyboardType: TextInputType.number,
      // Same thing as the widget above ^^^
      initialValue: product == null ? '' : product.price.toString(),
      // Also same thing as the widget above ^^^
      decoration: InputDecoration(labelText: 'Product Price'),
      // Validates the user input via a Regular Expression
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number';
        }
      },
      // Runs on submit
      onSaved: (String value) {
        setState(() {
          // Assigns value to the form map
          _formData['price'] = double.parse(value);
        });
      },
    );
  }

  // The submit button widget
  Widget _buildSubmitButton() {
    // Returns a ScopedModelDescendant
    // Will need access to the product model
    // Because the button will call a function that will assign the map to the model
    return ScopedModelDescendant<MainModel>(
      // Requires a builder
      builder: (BuildContext context, Widget child, MainModel model) {
        // Then returns the actual widget we want which is a button
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                // Set the label to 'Save' by giving it a Text widget as a child
                child: Text('Save'),
                // Set the color of label
                textColor: Colors.white,
                // When the button is pressed, execute _submitForm() function
                // Pass the model's functions through and also the selected product index
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex),
              );
      },
    );
  }

  // A widget that will return the page content
  Widget _buildPageContent(BuildContext context, Product product) {
    // Find the width of the device
    final double deviceWidth = MediaQuery.of(context).size.width;
    // Set what we want the width to be (Aimed at landscape mode)
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    // Create a padding
    final double targetPadding = deviceWidth - targetWidth;
    // Not entirely sure why we return a GestureDetector ?????
    // Do we need it????
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      // The main container for our form
      child: Container(
        // Listviews always take the avaliable space ignoring the width of the container
        width: targetWidth, // Does not work
        // Add a margin around the form
        margin: EdgeInsets.all(10.0),
        // Sets the form as the child
        child: Form(
          // Pass in the unique key from above
          key: _formKey,
          // Set the child to the list view
          child: ListView(
            // Add some padding to make it pretty :D
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            // Create an array of widgets that we built above for the form
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              // Add some spacing
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton()
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My Button'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  // Function that is executed when the submit button is pressed
  // Needs 3 functions and a optional index as an int
  // Product index would only be given if we are updated an existing product
  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    // Validation
    // Dosn't run validation until submit button is pressed
    if (!_formKey.currentState.validate()) {
      // Returning nothing will quit the function without executing anything bellow
      return;
    }
    // After validation, run all the onSave sections in the form
    _formKey.currentState.save();
    // If a product index was not given, create a new product
    if (selectedProductIndex == null) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((_) => // Once the data has been sent navigate to the products page
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null)));
      // If there was a product index that was given, update the current one
    } else {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      );
    }
    // Once the data has been sent navigate to the products page
    Navigator.pushReplacementNamed(context, '/products')
        .then((_) => setSelectedProduct(null));
  }

  // Main build menu
  @override
  Widget build(BuildContext context) {
    // Wrap in scoped model because we need to get the selected product
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        // Create the page content and store in a variable
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        // If statment that detects if it should show the Edit Product app bar
        return model.selectedProductIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
