import 'package:scoped_model/scoped_model.dart';

import './connected_products.dart';

// 'with' means murge 
class MainModel extends Model with ConnectedProductsModel, UserModel, ProductsModel {}