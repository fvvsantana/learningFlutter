import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    //return Map.from(items);
    return Map.from(_items);
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    return _items.keys
        .fold(0, (sum, key) => sum + _items[key].quantity * _items[key].price);
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    final cartItem = _items[productId];
    if (cartItem.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (oldCartItem) => CartItem(
            id: oldCartItem.id,
            title: oldCartItem.title,
            price: oldCartItem.price,
            quantity: oldCartItem.quantity - 1),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
