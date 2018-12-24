import 'package:flutter/material.dart';

// Create an object of type User to use across the app

class User {
  final String id;
  final String email;
  final String password;

  User({@required this.id, @required this.email, @required this.password});
}
