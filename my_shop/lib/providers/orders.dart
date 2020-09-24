import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/product.dart';
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

  Future<void> fetchAndSetOrders() async {
    final url = '${Links.databaseUrl}/orders.json';
    final response = await http.get(url);
    /*
    I/flutter (19882): {"-MHwCIZI0D4RrgRSDz6-":{"amount":1172.99,"dateTime":"2020-09-23T15:23:55.653703","products":[{"id":"2020-09-23 15:23:46.043121","price":1.99,"quantity":1,"title":"test"},{"id":"2020-09-23 15:23:46.882453","price":1093.0,"quantity":1,"title":"one"},{"id":"2020-09-23 15:23:47.281641","price":78.0,"quantity":1,"title":"hey dude!"}]}}
    */
    final List<OrderItem> loadedOrders = [];
    Map<String, dynamic> extractedData = json.decode(response.body);
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((cartItem) => CartItem(
                  id: cartItem['id'],
                  title: cartItem['title'],
                  quantity: cartItem['quantity'],
                  price: cartItem['price'],
                ))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = '${Links.databaseUrl}/orders.json';
    final now = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'price': prod.price,
                    'quantity': prod.quantity,
                  })
              .toList(),
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
