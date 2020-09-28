import 'dart:async';
import 'dart:convert';

import 'package:flutter_complete_guide/utils/links.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String userId;
  Timer _timer;

  bool get isAuthenticated{
    return token != null;
  }

  String get token{
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String url) async{
    final response = await http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));
    final data = json.decode(response.body);
    if(data == null) return;
    _token = data['idToken'];
    userId = data['localId'];
    _expiryDate = DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
    if(_timer != null){
      _timer.cancel();
      _timer = null;
      _autoSignOut();
    }else{
      _autoSignOut();
    }
    notifyListeners();
    
  }

  Future<void> signUp(String email, String password) async{
    return _authenticate(email, password, Links.signUpUrl);
  }

  Future<void> signIn(String email, String password) async{
    return _authenticate(email, password, Links.signInUrl);
  }

  void signOut(){
    _token = null;
    _expiryDate = null;
    userId = null;
    if(_timer != null){
      _timer.cancel();
      _timer = null;
    }
    notifyListeners();
  }

  void _autoSignOut(){
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    if(_timer == null){
      _timer = Timer(Duration(seconds: timeToExpiry), signOut);
    }
  }
}