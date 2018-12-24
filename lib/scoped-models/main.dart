// Combine all the models into one model so that multiple models are accessable across the app

import 'package:scoped_model/scoped_model.dart';

import './connected_products.dart';

// 'with' means murge 
class MainModel extends Model with ConnectedProductsModel, UserModel, ProductsModel {}