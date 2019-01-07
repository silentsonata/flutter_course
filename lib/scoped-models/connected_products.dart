// External Inports
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

// Internal Inports
import '../models/product.dart';
import '../models/user.dart';

// Not sure why adding a product is in it's own class
mixin ConnectedProductsModel on Model {
  // Holds a list of all the products
  List<Product> _products = [];
  // Holds the data of the authenticated user
  User _authenticatedUser;
  // The integer of the selected product for the array list above
  int _selProductIndex;
  // A bool that tells if page is loading
  bool _isLoading = false;

  // A function that adds a product to the users database
  /*  title: The title of the product
      description: The description of the product
      image: A Url to the image
      price: The amount for the product
  */
  Future<Null> addProduct(
      String title, String description, String image, double price) {
    // Shows loading page
    _isLoading = true;
    notifyListeners();
    // Preps a product from the values passed into the function and includes the userEmail and userId
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://www.google.com/url?sa=i&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwizhOHDs4bfAhVyhOAKHaWrAkYQjRx6BAgBEAU&url=https%3A%2F%2Fschrammsflowers.com%2Fproduct%2Fchocolate-candy-basket%2F&psig=AOvVaw3TSveQyYmK3cw3MBiydBns&ust=1544020710265451',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
    };
    // Http request to store data to firebase
    return http
        .post('https://flutter-products-44a29.firebaseio.com/products.json',
            // Convert the list into json because that is how firebase stores its data
            body: json.encode(productData))
        // Run this code after the data is uploaded.
        // This is fetch the data from the server and move it to RAM
        .then((http.Response response) {
      // Create a dummy map to temporarily store fetch data
      // We need to fetch the data again because we need the ID of where the data was stored
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Create a dummy new product
      final Product newProduct = Product(
          // Store the ID from the server
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      // Add the new product to the product array
      _products.add(newProduct);

      // Will stop showing loading
      _isLoading = false;
      // notifyListeners is called when the model has changed.
      // Since we added a product the model has changed it must notify all listeners that the change happened.
      notifyListeners();
    });
  }
}

mixin ProductsModel on ConnectedProductsModel {
  // A toggle wether or not to show only favorites
  bool _showFavorites = false;

  // A getter to fetch all the products
  List<Product> get allProducts {
    // Returns a copy of the list and not the actual list
    return List.from(_products);
  }

  /*  A getter to display all the products. Kinda similar to allProducts but all products will 
      fectch favorited and non favorited products where as displayProducts will sometimes only
      show favorites.
  */
  List<Product> get displayedProducts {
    // if true return only favorites
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavoirite).toList();
    }
    // Otherwise return all the products
    return List.from(_products);
  }

  // A getter that returns the selected product index
  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    // If no product is sellected will return null. A better way to do this would just return the selected
    // product without the if statment.
    // TODO: Already returning null
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  // A getter that returns weather or not it is showing favorites only
  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  // Function to update a product
  void updateProduct(
      String title, String description, String image, double price) {
    // Create a dummy updated product
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    // Overwrite the product at the selected index with the updated product
    _products[selectedProductIndex] = updatedProduct;
    // Let all listeners know that the model has changed
    notifyListeners();
  }

  // Function to delete the selected product
  void deleteProduct() {
    // Removes product at the selected index
    _products.removeAt(selectedProductIndex);
    // Let everyone know something is different ;)
    notifyListeners();
  }

  // A function that fetches the products from the server
  void fetchProducts() {
    // Page will show loading
    _isLoading = true;
    notifyListeners();
    // http start with the link to the server
    http
        .get('https://flutter-products-44a29.firebaseio.com/products.json')
        .then(
      (http.Response response) {
        // Create a list that all fetched products will be added to
        final List<Product> fetchedProductList = [];
        // Create a map of all the products being fetched from the server
        final Map<String, dynamic> productListData = json.decode(response.body);

        // Check to see if returned null indicating there are no products
        if (productListData == null) {
          // Completed loading
          _isLoading = false;
          // Notify all listeners in the model
          notifyListeners();
          // Return nothing to exit the function
          return;
        }

        // For each product in the map store to fetchedProductList
        productListData.forEach(
          (String productId, dynamic productData) {
            // Create a temporary product to store
            final Product product = Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              image: productData['image'],
              price: productData['price'],
              userEmail: productData['userEmail'],
              userId: productData['userId'],
            );
            // Store the product in fetched products
            fetchedProductList.add(product);
            // Loops until there are no more entries
          },
        );
        // Stor all fetched products to the main products list
        _products = fetchedProductList;

        // Set page loading to false
        _isLoading = false;
        // Let em all know something up
        notifyListeners();
      },
    );
  }

  // A function that toggles the favorite filter
  void toggleProductFavoriteStatues() {
    // Fetches from the current product to get the bool if product is favorite
    final bool isCurrentlyFavorite = selectedProduct.isFavoirite;
    // Inverts the status of the selected product
    final bool newFavoriteStatues = !isCurrentlyFavorite;
    // Create an updated product that adds the isFavorite section to the product
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavoirite: newFavoriteStatues);

    // Apply that updated product to the product list at the selected index
    _products[selectedProductIndex] = updatedProduct;
    // Wake up the cattle
    notifyListeners();
  }

  // A function to select a product at a desired index
  void selectProduct(int index) {
    // Store the index in the selected product variable
    _selProductIndex = index;
    // If the selected index is anything but null (which is the index when app starts) update everyone
    if (_selProductIndex != null) {
      notifyListeners();
    }
  }

  // A funcation that will toggle the display mode between favorite and all products
  void toggleDisplayMode() {
    // Invert the show favorites when toggled
    // If favorites are showing set to 'true' and when all are showing 'false'
    _showFavorites = !_showFavorites;
    // Update all the dummies ;P
    notifyListeners();
  }
}

// Class that holds the user model
mixin UserModel on ConnectedProductsModel {
  // A function that creates the user
  void login(String email, String password) {
    // Adds the user under _authenticatedUser
    // Id is static right now but should be updated latter
    _authenticatedUser =
        User(id: '3824234234', email: email, password: password);
  }
}


mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}