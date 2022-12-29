import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Alterna o valor da variável isFavorite
  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
