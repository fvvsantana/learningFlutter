import 'dart:convert';

import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/utils/links.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
/*
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    */
  ];

  String token;
  String userId;

  List<Product> get items {
    return List<Product>.from(_items);
  }

  List<Product> get favoritesOnly {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool userProductsOnly = false]) async {
    String productsUrl;
    if(userProductsOnly){
      productsUrl = '${Links.databaseUrl}/products.json?auth=$token&orderBy="creatorId"&equalTo="$userId"';
    }else{
      productsUrl = '${Links.databaseUrl}/products.json?auth=$token&';
    }
    http.Response response;
    try {
      response = await http.get(productsUrl);
    } catch (error) {
      throw error;
    }

    final Map<String, dynamic> data = json.decode(response.body);
    if(data == null){
      return;
    }


    final favUrl = '${Links.databaseUrl}/userFavorites/$userId.json?auth=$token';
    final favResponse = await http.get(favUrl);
    final favData = json.decode(favResponse.body);


    List<Product> fetchedProducts = [];
    data.forEach((prodId, prodData) {
      final product = Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        imageUrl: prodData['imageUrl'],
        isFavorite: favData == null? false: favData[prodId] ?? false,
      );
      fetchedProducts.add(product);
    });
    _items = fetchedProducts;

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url = '${Links.databaseUrl}/products.json?auth=$token';
    http.Response response;
    try {
      response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
            'creatorId': userId,
          }));
    } catch (error) {
      print(error);
      throw error;
    }

    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      isFavorite: product.isFavorite,
    ));
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(Product product) async {
    // Update remotely
    final url =
        '${Links.databaseUrl}/products/${product.id}.json?auth=$token';
    await http.patch(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }));

    // Update locally
    final index = _items.indexWhere((prod) => prod.id == product.id);
    _items[index] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    // Opmitistic deletion
    final url = '${Links.databaseUrl}/products/$id.json?auth=$token';
    final index = _items.indexWhere((prod) => prod.id == id);
    final product = _items.elementAt(index);
    _items.removeAt(index);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw HttpException('Couldn\'t delete product');
    }
  }
}
