import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/utils/links.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return List.from(_orders);
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = '${Links.databaseUrl}/orders.json';
    final now = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartProducts.map((prod) => {
                'id': prod.id,
                'title': prod.title,
                'price': prod.price,
                'quantity': prod.quantity,
              }).toList(),
          'dateTime': now.toIso8601String(),
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: now,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
