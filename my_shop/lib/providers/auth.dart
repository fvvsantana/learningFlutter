import 'dart:convert';

import 'package:flutter_complete_guide/utils/links.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier{
  String _token;
  String _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async{
    final response = await http.post(Links.authUrl, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));
    print(response.body);

  }

}