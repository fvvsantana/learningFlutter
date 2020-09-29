import 'dart:async';
import 'dart:convert';

import 'package:flutter_complete_guide/utils/links.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String userId;
  Timer _timer;

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      // Get authetication token
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final data = json.decode(response.body);
      if (data == null) return;
      _token = data['idToken'];
      userId = data['localId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));

      // Store user data on shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }

    // Set timer for _autoSignOut
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      _autoSignOut();
    } else {
      _autoSignOut();
    }
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, Links.signUpUrl);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, Links.signInUrl);
  }

  Future<bool> tryLoadAuthData() async {
    // Load shared preferences and check if I have the file
    final prefs = await SharedPreferences.getInstance();
    final userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    if (userData == null) {
      return false;
    }

    final storedDate = DateTime.parse(userData['expiryDate']);
    // Check if expiryDate is not valid
    if (storedDate.isBefore(DateTime.now())) {
      return false;
    }

    // Set user data
    _token = userData['token'];
    userId = userData['userId'];
    _expiryDate = storedDate;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _token = null;
    _expiryDate = null;
    userId = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }

    // Remove shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');

    notifyListeners();
  }

  void _autoSignOut() {
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    if (_timer == null) {
      _timer = Timer(Duration(seconds: timeToExpiry), signOut);
    }
  }
}
