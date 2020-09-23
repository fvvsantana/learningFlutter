import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  static const baseUrl = 'https://my-shop-82dad.firebaseio.com';
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });


  Future<void> toggleIsFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = '$baseUrl/products/$id';

    http.Response response;
    final revertFavorite = () {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Couldn\'t update favorite.');
    };

    try {
      response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
    } catch (error) {
      try {
        revertFavorite();
      } catch (_) {
        rethrow;
      }
    }
    if (response.statusCode >= 400) {
      try {
        revertFavorite();
      } catch (_) {
        rethrow;
      }
    }
  }
}
