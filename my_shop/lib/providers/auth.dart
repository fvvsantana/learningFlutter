import 'dart:convert';

import 'package:flutter_complete_guide/utils/links.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier{
  String _token;
  String _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password, String url) async{
    final response = await http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));
    print(response.body);
  }

  Future<void> signUp(String email, String password) async{
    return _authenticate(email, password, Links.signUpUrl);
  }

  Future<void> signIn(String email, String password) async{
    return _authenticate(email, password, Links.signInUrl);
  }

}