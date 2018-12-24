// Import all external packages
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// Import local packages
import '../scoped-models/main.dart';

// Create a stateful widget (a widget that changes)
class AuthPage extends StatefulWidget {
  @override
  State createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Create a map that holds the data from the form
  final Map<String, dynamic> _authForm = {
    'email': null,
    'password': null,
    'acceptTerms': false,
  };

  // Assigns the form to this unique global key so that the form is uniquely identified
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Image behind the form
  _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(.5), BlendMode.dstATop),
      image: AssetImage('assets/background.jpg'),
    );
  }

  // Email text field
  _buildEmailTextField() {
    // Returns a Text Form Field
    return TextFormField(
      // Sets the type of the text form
      keyboardType: TextInputType.emailAddress,
      // Decorate the text field with label and background color
      decoration: InputDecoration(
        labelText: 'E-mail',
        filled: true,
        fillColor: Colors.white,
      ),
      // Validate the input on the text field
      // The returned value is the error. If validation passes return null.
      validator: (String value) {
        // Optained regular expresion from the internet ;)
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Invalid E-mail';
        }
      },
      // Code runs on form save (submit)
      onSaved: (String value) {
        // Saves the value in text field to the _authForm map.
        _authForm['email'] = value;
      },
    );
  }

  // Password Text Field
  _buildPasswordTextField() {
    return TextFormField(
      // Hides input and replaces it with *
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      // Same idea as the email text field
      validator: (String value) {
        if (value.isEmpty || value.length <= 6) {
          return 'Invalid Password';
        }
      },
      // Saves value to _authForm
      onSaved: (String value) {
        _authForm['password'] = value;
      },
    );
  }

  // Builds the accept terms switch
  _buildAcceptSwitch() {
    return SwitchListTile(
      // Assigns where the value will be stored
      value: _authForm['acceptTerms'],
      // When the toggle switch is changed run this code
      onChanged: (bool value) {
        // Run setState because there is a visual change to the state.
        // (The switch sliding)
        setState(() {
          // Assing the value of the switch (true/false) to the _authForm map
          _authForm['acceptTerms'] = value;
        });
      },
      // Create the title next to the switch
      title: Text('Accept Terms'),
    );
  }

  // Function that runs when the form is submitted
  void _submitForm(Function login) {
    // _formKey.currentState.validate() will run all the validation code for all text fields
    // Also will check to see if the terms were accepted
    if (!_formKey.currentState.validate() || !_authForm['acceptTerms']) {
      // If anything is returned....not sure lol
      // Interesting code.... :-|
      return;
    }
    // Saves the form
    // Also runs all the onSave sections on the form widgets
    _formKey.currentState.save();
    // Send the data over to the module
    login(_authForm['email'], _authForm['password']);
    // Change the page to the default products page via named routes
    Navigator.pushReplacementNamed(context, '/products');
  }

  // First function to execute
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    /* 
      () > () -- condition
      ? -- if condition is true do what follows
      : -- else section
    */
    // Limits how wide the text forms get. If screen has small width make width 95% of the width.
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    // Our first scaffold :D
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          // Sets the background image
          image: _buildBackgroundImage(),
        ),
        // Applies padding
        padding: EdgeInsets.all(10.0),
        // Creates a center Widget that will hold the form
        child: Center(
          // Create a single child scroll view to hold the container if the screen is too small
          child: SingleChildScrollView(
            // Creates a container that centers and has a width defined as tagetWidth from above
            child: Container(
              alignment: Alignment.center,
              width: targetWidth,

              // Our Form!!!
              child: Form(
                // Assign global key to the form
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Build email text field
                    _buildEmailTextField(),
                    // Create a space between fields
                    SizedBox(
                      height: 10.0,
                    ),
                    // Build password text field
                    _buildPasswordTextField(),
                    // Build accept terms switch
                    _buildAcceptSwitch(),
                    // More spacing
                    SizedBox(
                      height: 10.0,
                    ),
                    // Button wrapped in the scoped model decendant to access login information
                    ScopedModelDescendant(
                      // Needs a builder
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return RaisedButton(
                          // Style button
                          child: Text(
                            'Log In',
                            style: TextStyle(color: Colors.white),
                          ),
                          // When button is pressed execute the _submitForm funciton.
                          // Also passes in the function from the model (connected_products.dart) login().
                          onPressed: () => _submitForm(model.login),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
