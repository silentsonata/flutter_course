import 'package:scoped_model/scoped_model.dart';

import './products.dart';
import './user.dart';

// 'with' means murge 
class MainModel extends Model with UserModel, ProductsModel {}