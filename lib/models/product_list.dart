import 'package:flutter/foundation.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  // Vamos retornar um clone/cópia
  // para o user não conseguir modificar
  List<Product> get item => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);
    // Atualiza de forma reativa a adição de um produto na lista
    notifyListeners();
  }
}

  // List<Product> _items = dummyProducts;
  // bool _showFavoriteOnly = false;

  // // Vamos retornar um clone/cópia
  // // para o user não conseguir modificar
  // List<Product> get item {
  //   if (_showFavoriteOnly) {
  //     return _items.where((prod) => prod.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }